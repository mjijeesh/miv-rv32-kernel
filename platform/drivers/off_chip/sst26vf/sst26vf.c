/***************************************************************************//**
 * (c) Copyright 2009 Actel Corporation.  All rights reserved.
 * 
 *  MICRON_1G_SPI_FLASH_ SPI flash driver API.
 *
 * SVN $Revision:$
 * SVN $Date:$
 */

#include "fpga_design_config/fpga_design_config.h"
#include "sst26vf.h"

//#include "../mss_pdma/mss_pdma.h"
//#include "CMSIS/system_m2sxxx.h"
//#include "hal.h"

#define READ_ARRAY_OPCODE   0x03
#define DEVICE_ID_READ      0x9F


#define WRITE_ENABLE_CMD    0x06
#define WRITE_DISABLE_CMD   0x04
#define PROGRAM_PAGE_CMD    0x02
#define WRITE_STATUS1_OPCODE    0x01
#define DIE_256MB_ERASE_OPCODE   0xC4
#define ERASE_4K_BLOCK_OPCODE   0x20
#define ERASE_64K_BLOCK_OPCODE  0xD8
#define READ_STATUS         0x05
#define ADDRESS_MODE_4BYTE    0xB7
#define READ_FLAG_STATUS_REGISTER 0x70
#define ERASE_4K_BLOCK  0
#define ERASE_64K_BLOCK  1
#define READY_BIT_MASK      0x01
#define GLOBAL_UNPROTECT 0x98

#define UNPROTECT_SECTOR_OPCODE     0x39

#define DONT_CARE       0x00u

#define NB_BYTES_PER_PAGE   256

#define CHIP_ERASE_OPCODE   0xC4




//# below reg offset for setting the spic lcok control reg
#define CLK_DIV_REG_OFFSET 0x2cu


#ifdef  CONFIG_USE_MSS_SPI
#include "drivers/mss_ip/mss_spi/mss_spi.h"
mss_spi_instance_t  *g_spi = &g_mss_spi0;

#define SPI_FLASH_INSTANCE   g_spi
#define SPI_FLASH_SLAVE      MSS_SPI_SLAVE_0


//# below reg offset for setting the spic lcok control reg
#define CLK_DIV_REG_OFFSET 0x2cu


#define  SPI_set_slave_select(spi_inst, slave)     MSS_SPI_set_slave_select( SPI_FLASH_INSTANCE, SPI_FLASH_SLAVE)
#define  SPI_clear_slave_select(spi_inst, slave)  MSS_SPI_clear_slave_select( SPI_FLASH_INSTANCE, SPI_FLASH_SLAVE )
#define  SPI_transfer_block( spi_inst,write_buff, write_size, read_buff, read_size)    MSS_SPI_transfer_block( SPI_FLASH_INSTANCE, write_buff, write_size, read_buff, read_size );


spi_flash_status_t FLASH_init( void )
{



     /*--------------------------------------------------------------------------
         * Configure SPI.
         */
        MSS_SPI_init( SPI_FLASH_INSTANCE );

        MSS_SPI_configure_master_mode
            (
                SPI_FLASH_INSTANCE,
                MSS_SPI_SLAVE_0,
                MSS_SPI_MODE3,
                8,
                MSS_SPI_BLOCK_TRANSFER_FRAME_SIZE
            );

     return 0;





}

#else

// this section if using CORESPI
#include "drivers/fpga_ip/CoreSPI/core_spi.h"

extern spi_instance_t  g_spi_0;

#define SPI_FLASH_INSTANCE   &g_spi_0

/*******************************************************************************
 *
 */
spi_flash_status_t sst26vf_spi_flash_init( void )
{
    /*--------------------------------------------------------------------------
     * Configure SPI.
     */

    SPI_init(SPI_FLASH_INSTANCE, CORESPI_FLASH_BASE_ADDR,32 );
    SPI_configure_master_mode( SPI_FLASH_INSTANCE );
    /* set the spi clock divisions */
    HAL_set_8bit_reg(CORESPI_FLASH_BASE_ADDR, CLK_DIV, 8 );
    SPI_enable(SPI_FLASH_INSTANCE);
    return 0;




}


spi_flash_status_t FLASH_init( void )
{
    /*--------------------------------------------------------------------------
     * Configure SPI.
     */

    SPI_init(SPI_FLASH_INSTANCE, CORESPI_FLASH_BASE_ADDR,32 );
    SPI_configure_master_mode( SPI_FLASH_INSTANCE );
    /* set the spi clock divisions */
    HAL_set_8bit_reg(CORESPI_FLASH_BASE_ADDR, CLK_DIV, 8 );
    SPI_enable(SPI_FLASH_INSTANCE);
    return 0;




}


#endif



/*******************************************************************************
 * Local functions
 */
static void wait_ready( void );

static void write_enable();

static void write_cmd_data
(

		const uint8_t * cmd_buffer,
		uint16_t cmd_byte_size,
		uint8_t * data_buffer,
		uint16_t data_byte_size
);


/*******************************************************************************
 *
 */
spi_flash_status_t FLASH_read_device_id
(
		uint8_t * manufacturer_id,
		uint8_t * device_id
)
{
	uint8_t read_device_id_cmd = DEVICE_ID_READ;
	uint8_t read_buffer[2];
	*manufacturer_id = 0;
	*device_id = 0;
	SPI_set_slave_select(SPI_FLASH_INSTANCE, SPI_SLAVE_0);
	SPI_transfer_block( SPI_FLASH_INSTANCE, &read_device_id_cmd, 1, read_buffer, sizeof(read_buffer) );
	SPI_clear_slave_select(SPI_FLASH_INSTANCE, SPI_SLAVE_0 );
	*manufacturer_id = read_buffer[0];
	*device_id = read_buffer[1];
	return 0;
}

/*******************************************************************************
 *
 */
spi_flash_status_t FLASH_read
(
		uint32_t address,
		uint8_t * rx_buffer,
		size_t size_in_bytes
)
{
	uint8_t cmd_buffer[4];

	//write_enable();
	//enter_4byte_address_mode();

	cmd_buffer[0] = READ_ARRAY_OPCODE;
	cmd_buffer[1] = (uint8_t)((address >> 16) & 0xFF);
	cmd_buffer[2] = (uint8_t)((address >> 8) & 0xFF);
	cmd_buffer[3] = (uint8_t)(address & 0xFF);

	SPI_set_slave_select(SPI_FLASH_INSTANCE, SPI_SLAVE_0);
	wait_ready();
	SPI_transfer_block( SPI_FLASH_INSTANCE, cmd_buffer, 4, rx_buffer, size_in_bytes );
	wait_ready();
	SPI_clear_slave_select(SPI_FLASH_INSTANCE, SPI_SLAVE_0 );
	return 0;

}

/*******************************************************************************
 *
 */
spi_flash_status_t FLASH_global_unprotect( void )
{
	uint8_t cmd_buffer[2];
	write_enable();
	cmd_buffer[0] = GLOBAL_UNPROTECT;
	cmd_buffer[1] = 0;

	SPI_set_slave_select(SPI_FLASH_INSTANCE, SPI_SLAVE_0);
	//wait_ready();
	SPI_transfer_block( SPI_FLASH_INSTANCE, cmd_buffer, 2, 0, 0 );
	//wait_ready();
	SPI_clear_slave_select(SPI_FLASH_INSTANCE, SPI_SLAVE_0 );
	return 0;

}

/*******************************************************************************
 *
 */
static void write_cmd_data
(

		const uint8_t * cmd_buffer,
		uint16_t cmd_byte_size,
		uint8_t * data_buffer,
		uint16_t data_byte_size
)
{

	uint8_t tx_buffer[520];
	uint16_t transfer_size;
	uint16_t idx = 0;

	transfer_size = cmd_byte_size + data_byte_size;

	for(idx = 0; idx < cmd_byte_size; ++idx)
	{
		tx_buffer[idx] = cmd_buffer[idx];
	}

	for(idx = 0; idx < data_byte_size; ++idx)
	{
		tx_buffer[cmd_byte_size + idx] = data_buffer[idx];
	}

	SPI_transfer_block( SPI_FLASH_INSTANCE, tx_buffer, transfer_size, 0, 0 );

	wait_ready();

/*
	while ( !MSS_SPI_tx_done(this_spi) )
	{
		;
	} */
}
static void write_enable()
{
	uint8_t cmd_buffer;
	SPI_set_slave_select( SPI_FLASH_INSTANCE,SPI_SLAVE_0 );
	/* Send Write Enable command */
	cmd_buffer = WRITE_ENABLE_CMD;
	//wait_ready();
	SPI_transfer_block( SPI_FLASH_INSTANCE, &cmd_buffer, 1, 0, 0 );
	//wait_ready();
	SPI_clear_slave_select( SPI_FLASH_INSTANCE,SPI_SLAVE_0);
}

spi_flash_status_t FLASH_program
(
		uint32_t address,
		uint8_t * write_buffer,
		size_t size_in_bytes
)
{
	uint8_t cmd_buffer[4];

	uint32_t in_buffer_idx;
	uint32_t nb_bytes_to_write;
	uint32_t target_addr;



	in_buffer_idx = 0;
	nb_bytes_to_write = size_in_bytes;
	target_addr = address;

	while ( in_buffer_idx < size_in_bytes )
	{
		uint32_t size_left;
		nb_bytes_to_write = 0x100 - (target_addr & 0xFF);   /* adjust max possible size to page boundary. */
		size_left = size_in_bytes - in_buffer_idx;
		if ( size_left < nb_bytes_to_write )
		{
			nb_bytes_to_write = size_left;
		}


		write_enable();
		/* Program page */


		cmd_buffer[0] = PROGRAM_PAGE_CMD;
		cmd_buffer[1] = (uint8_t)((target_addr >> 16) & 0xFF);
		cmd_buffer[2] = (uint8_t)((target_addr >> 8) & 0xFF);
		cmd_buffer[3] = (uint8_t)(target_addr & 0xFF);
		SPI_set_slave_select( SPI_FLASH_INSTANCE, SPI_SLAVE_0 );
		wait_ready();
		write_cmd_data
		(

				cmd_buffer,
				sizeof(cmd_buffer),
				&write_buffer[in_buffer_idx],
				nb_bytes_to_write
		);
		wait_ready();

		SPI_clear_slave_select( SPI_FLASH_INSTANCE, SPI_SLAVE_0 );
		target_addr += nb_bytes_to_write;
		in_buffer_idx += nb_bytes_to_write;
	}

	/* Send Write Disable command. */
	SPI_set_slave_select(SPI_FLASH_INSTANCE, SPI_SLAVE_0 );
	cmd_buffer[0] = WRITE_DISABLE_CMD;
	wait_ready();
	SPI_transfer_block( SPI_FLASH_INSTANCE, cmd_buffer, 1, 0, 0 );
	wait_ready();
	SPI_clear_slave_select(SPI_FLASH_INSTANCE, SPI_SLAVE_0 );
	return 0;
}


/*******************************************************************************
 *
 */

static void wait_ready( void )
{
	uint8_t ready_bit;
	uint8_t command = READ_STATUS;

	do {

		SPI_transfer_block( SPI_FLASH_INSTANCE, &command, sizeof(command), &ready_bit, sizeof(ready_bit) );
		ready_bit = ready_bit & READY_BIT_MASK;

	} while( ready_bit == 1 );

}
/*******************************************************************************
 *
 *address : starting address to erase the 64k flash

 */
spi_flash_status_t FLASH_erase_64k_block
(
		uint32_t address
)
{

	uint8_t cmd_buffer[5];
	/* Send Write Enable command */


	write_enable();


	SPI_set_slave_select(SPI_FLASH_INSTANCE, SPI_SLAVE_0);


	cmd_buffer[0] = ERASE_64K_BLOCK_OPCODE;


	cmd_buffer[1] = (uint8_t)((address >> 16) & 0xFF);
	cmd_buffer[2] = (uint8_t)((address >> 8) & 0xFF);
	cmd_buffer[3] = (uint8_t)(address & 0xFF);
	wait_ready();
	SPI_transfer_block(SPI_FLASH_INSTANCE, cmd_buffer,4, 0, 0 );
	wait_ready();

	SPI_clear_slave_select(SPI_FLASH_INSTANCE, SPI_SLAVE_0);

	return 0;

}

spi_flash_status_t FLASH_erase_4k_block
(
		uint32_t address
)
{

	uint8_t cmd_buffer[5];
	/* Send Write Enable command */

	//write_enable();
	//enter_4byte_address_mode();
	write_enable();


	SPI_set_slave_select(SPI_FLASH_INSTANCE, SPI_SLAVE_0);


	cmd_buffer[0] = ERASE_4K_BLOCK_OPCODE;
	cmd_buffer[1] = (uint8_t)((address >> 16) & 0xFF);
	cmd_buffer[2] = (uint8_t)((address >> 8) & 0xFF);
	cmd_buffer[3] = (uint8_t)(address & 0xFF);
	wait_ready();
	SPI_transfer_block(SPI_FLASH_INSTANCE, cmd_buffer,4, 0, 0 );
	wait_ready();

	SPI_clear_slave_select(SPI_FLASH_INSTANCE, SPI_SLAVE_0);

   return 0;

}


/*******************************************************************************
 *
 */

spi_flash_status_t FLASH_chip_erase (void)
{

    uint8_t cmd_buffer[5];
    uint32_t address =0;
    /* Send Write Enable command */


    write_enable();


    SPI_set_slave_select(SPI_FLASH_INSTANCE, SPI_SLAVE_0);


    cmd_buffer[0] = CHIP_ERASE_OPCODE;


    cmd_buffer[1] = (uint8_t)((address >> 16) & 0xFF);
    cmd_buffer[2] = (uint8_t)((address >> 8) & 0xFF);
    cmd_buffer[3] = (uint8_t)(address & 0xFF);
    wait_ready();
    SPI_transfer_block(SPI_FLASH_INSTANCE, cmd_buffer,4, 0, 0 );
    wait_ready();

    SPI_clear_slave_select(SPI_FLASH_INSTANCE, SPI_SLAVE_0);

    return 0;

}


