#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "hal/hal.h"
#include "miv_rv32_hal/miv_rv32_hal.h"
#include "drivers/fpga_ip/CoreGPIO/core_gpio.h"
#include "drivers/fpga_ip/CoreUARTapb/core_uart_apb.h"
#include "drivers/fpga_ip/CoreSPI/core_spi.h"

#include "fpga_design_config/fpga_design_config.h"

#include "sfl.h"
#include "crc.h"

// Define your Mi-V Base Addresses (Update these based on Libero design)
//#define UART_BASE_ADDR   0x70000000 
#define TIMER_FREQ       SYS_CLK_FREQ 

#define ACK_TIMEOUT_DELAY (TIMER_FREQ / 4)
#define CMD_TIMEOUT_DELAY (TIMER_FREQ / 4)


extern UART_instance_t g_uart;


void boot_helper(unsigned long r1, unsigned long r2, unsigned long r3, unsigned long addr);
void boot_helper(unsigned long r1, unsigned long r2, unsigned long r3, unsigned long addr) {
    goto *(void*)addr;


}



enum {
	ACK_TIMEOUT,
	ACK_CANCELLED,
	ACK_OK
};

//extern void boot_helper(unsigned long r1, unsigned long r2, unsigned long r3, unsigned long addr);
void __attribute__((noreturn)) boot(unsigned long r1, unsigned long r2, unsigned long r3, unsigned long addr)
{
	printf("Executing booted program at 0x%08lx\n\n", addr);
	printf("Liftoff!");

	boot_helper(r1, r2, r3, addr);
	while(1);
}


/***************************************************************************//**
  The MRV_read_mtime() function returns the current MTIME register value.
 */
static inline uint64_t MRV_get_mtime(void)
{
    volatile uint32_t hi = 0u;
    volatile uint32_t lo = 0u;

    /* when mtime lower word is 0xFFFFFFFF, there will be rollover and
     * returned value could be wrong. */
    do {
        hi = MTIMEH;
        lo = MTIME;
    } while(hi != MTIMEH);

    return((((uint64_t)MTIMEH) << 32u) | lo);
}


/* --- Timer Logic (Using RISC-V mtime) --- */
static uint64_t get_timeout_time(uint32_t delay) {
    return MRV_get_mtime() + delay;
}

static int timer_expired(uint64_t expiration) {
    return (MRV_get_mtime() >= expiration);
}

/* --- UART Abstraction --- */
static int miv_uart_read_nonblock(uint8_t *c) {
    return UART_get_rx(&g_uart, c,1);
}

static void miv_uart_write(uint8_t c) {
    UART_send(&g_uart, &c, 1);
}

/* --- Protocol Logic --- */
static int check_ack(void) {
    int recognized = 0;
    uint8_t c;
    static const char str[SFL_MAGIC_LEN] = SFL_MAGIC_ACK;
    
    uint64_t timeout = get_timeout_time(ACK_TIMEOUT_DELAY);

    while(!timer_expired(timeout)) {
        if(miv_uart_read_nonblock(&c)) {
            if((c == 'Q') || (c == 0x1B)) return ACK_CANCELLED;
            
            if(c == str[recognized]) {
                recognized++;
                if(recognized == SFL_MAGIC_LEN) return ACK_OK;
            } else {
                recognized = (c == str[0]) ? 1 : 0;
            }
        }
    }
    return ACK_TIMEOUT;
}



static uint32_t get_uint32(unsigned char* data)
{
	return ((uint32_t) data[0] << 24) |
			 ((uint32_t) data[1] << 16) |
			 ((uint32_t) data[2] << 8) |
			  (uint32_t) data[3];
}

#define MAX_FAILURES 256

static int serialboot_fail(int *failures)
{
	(*failures)++;
	if(*failures >= MAX_FAILURES) {
		printf("Too many consecutive errors, aborting\n");
		return 1;
	}
	return 0;
}

/* Define your specific target memory location */
#define MY_TARGET_ADDRESS 0x80000000 // Example: Start of your DDR or SRAM

int serialboot(void) {
    struct sfl_frame frame;
    int failures = 0;
    const char *req = SFL_MAGIC_REQ;
    uint8_t rx_byte;

    int ack_status;
    static const char str[SFL_MAGIC_LEN+1] = SFL_MAGIC_REQ;
    const char *c;

    #if 0

    printf("Mi-V Serial Boot...\n");

    // Send Magic Request
    for(int i=0; i<SFL_MAGIC_LEN; i++) miv_uart_write(req[i]);

    if(check_ack() != ACK_OK) {
        printf("Handshake Failed\n");
        return 1;
    }
    #endif 

    printf("Booting from serial...\n");
	printf("Press Q or ESC to abort boot completely.\n");

	/* Send the serialboot "magic" request to Host and wait for ACK_OK */
	c = str;
	while(*c) {
		miv_uart_write(*c);
		c++;
	}

    ack_status = check_ack();
	if(ack_status == ACK_TIMEOUT) {
		printf("Timeout\n");
		return 1;
	}
	if(ack_status == ACK_CANCELLED) {
		printf("Cancelled\n");
		return 0;
	}


    /* Assume ACK_OK */
	failures = 0;

    while(1) {
		int i;
		int timeout;
		int computed_crc;
		int received_crc;

		/* Get one Frame */
		i = 0;
		timeout = 1;
        int frame_timeout = 0;
        uint64_t timeout_val = get_timeout_time(CMD_TIMEOUT_DELAY);

        while(1) { 
			if (miv_uart_read_nonblock(&rx_byte)) {
				if (i == 0) frame.payload_length = rx_byte;
				if (i == 1) frame.crc[0] = rx_byte;
				if (i == 2) frame.crc[1] = rx_byte;
				if (i == 3) frame.cmd    = rx_byte;
				if (i >= 4) {
					frame.payload[i-4] = rx_byte;
				}
				if (i == (frame.payload_length + 4 - 1)) {
					timeout = 0;
					break;
				}
				i++;
                // Reset timeout window on successful byte reception
                timeout_val = get_timeout_time(CMD_TIMEOUT_DELAY);
			}

            if (timer_expired(timeout_val)) {
                frame_timeout = 1;
                break;
            }

			
		}     



		/* Check Timeout */
		if (frame_timeout) {
			/* Acknowledge the Timeout and continue with a new frame */
			miv_uart_write(SFL_ACK_ERROR);
			if(serialboot_fail(&failures))
				return 1;
			continue;
		}

		/* Check Frame CRC */
		received_crc = ((int)frame.crc[0] << 8)|(int)frame.crc[1];
		computed_crc = crc16(&frame.cmd, frame.payload_length + 1);
		if(computed_crc != received_crc) {
			/* Acknowledge the CRC error */
			miv_uart_write(SFL_ACK_CRCERROR);

			/* Increment failures and exit when max is reached */
			if(serialboot_fail(&failures))
				return 1;
			continue;
		}

		/* Execute Frame CMD */
		switch(frame.cmd) {
			/* On SFL_CMD_ABORT ... */
			case SFL_CMD_ABORT:
				/* Reset failures */
				failures = 0;
				/* Acknowledge and exit */
				miv_uart_write(SFL_ACK_SUCCESS);
				return 1;

			/* On SFL_CMD_LOAD... */
			case SFL_CMD_LOAD: {
				char *load_addr;

				if(frame.payload_length < 4) {
					miv_uart_write(SFL_ACK_ERROR);
					if(serialboot_fail(&failures))
						return 1;
					break;
				}

				/* Reset failures */
				failures = 0;

				/* Copy payload */
				//load_addr = (char *)(uintptr_t) get_uint32(&frame.payload[0]);
				load_addr = (char *)MY_TARGET_ADDRESS;
				memcpy(load_addr, &frame.payload[4], frame.payload_length - 4);


				


				/* Acknowledge and continue */
				miv_uart_write(SFL_ACK_SUCCESS);
				break;
			}
			/* On SFL_CMD_ABORT ... */
			case SFL_CMD_JUMP: {
				uint32_t jump_addr;

				if(frame.payload_length < 4) {
					miv_uart_write(SFL_ACK_ERROR);
					if(serialboot_fail(&failures))
						return 1;
					break;
				}

				/* Reset failures */
				failures = 0;

				/* Acknowledge and jump */
				miv_uart_write(SFL_ACK_SUCCESS);
				jump_addr = get_uint32(&frame.payload[0]);
				//boot(0, 0, 0, jump_addr);	
				return 0; // exit fro mthe loop after downlaod			
				break;
			}
			default:
				/* Acknowledge the UNKNOWN cmd */
				miv_uart_write(SFL_ACK_UNKNOWN);

				/* Increment failures and exit when max is reached */
				if(serialboot_fail(&failures))
					return 1;

				break;
		}
	}
	return 1;
}





    