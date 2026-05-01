#include "sdprint.h"
#include "sdcard.h"
#include "fpga_design_config/fpga_design_config.h"
#include "stdio/uart_stdio.h"

void SD_printR1(uint8_t res)
{
    if(res == 0xFF)
        { uart_print_text("\tNo response\r\n"); return; }
    if(res & 0x80)
        { uart_print_text("\tError: MSB = 1\r\n"); return; }
    if(res == 0)
        { uart_print_text("Card Ready\r\n"); return; }
    if(PARAM_ERROR(res))
        uart_print_text("\tParameter Error\r\n");
    if(ADDR_ERROR(res))
        uart_print_text("\tAddress Error\r\n");
    if(ERASE_SEQ_ERROR(res))
        uart_print_text("\tErase Sequence Error\r\n");
    if(CRC_ERROR(res))
        uart_print_text("\tCRC Error\r\n");
    if(ILLEGAL_CMD(res))
        uart_print_text("\tIllegal Command\r\n");
    if(ERASE_RESET(res))
        uart_print_text("\tErase Reset Error\r\n");
    if(IN_IDLE(res))
        uart_print_text("\tIn Idle State\r\n");
}

void SD_printR2(uint8_t *res)
{
    SD_printR1(res[0]);

    if(res[0] == 0xFF) return;

    if(res[1] == 0x00)
        uart_print_text("\tNo R2 Error\r\n");
    if(OUT_OF_RANGE(res[1]))
        uart_print_text("\tOut of Range\r\n");
    if(ERASE_PARAM(res[1]))
        uart_print_text("\tErase Parameter\r\n");
    if(WP_VIOLATION(res[1]))
        uart_print_text("\tWP Violation\r\n");
    if(CARD_ECC_FAILED(res[1]))
        uart_print_text("\tECC Failed\r\n");
    if(CC_ERROR(res[1]))
        uart_print_text("\tCC Error\r\n");
    if(ERROR(res[1]))
        uart_print_text("\tError\r\n");
    if(WP_ERASE_SKIP(res[1]))
        uart_print_text("\tWP Erase Skip\r\n");
    if(CARD_LOCKED(res[1]))
        uart_print_text("\tCard Locked\r\n");
}

void SD_printR3(uint8_t *res)
{
    SD_printR1(res[0]);

    if(res[0] > 1) return;

    uart_print_text("\tCard Power Up Status: ");
    if(POWER_UP_STATUS(res[1]))
    {
        uart_print_text("READY\r\n");
        uart_print_text("\tCCS Status: ");
        if(CCS_VAL(res[1])){ uart_print_text("1\r\n"); }
        else uart_print_text("0\r\n");
    }
    else
    {
        uart_print_text("BUSY\r\n");
    }

    uart_print_text("\tVDD Window: ");
    if(VDD_2728(res[3])) uart_print_text("2.7-2.8, ");
    if(VDD_2829(res[2])) uart_print_text("2.8-2.9, ");
    if(VDD_2930(res[2])) uart_print_text("2.9-3.0, ");
    if(VDD_3031(res[2])) uart_print_text("3.0-3.1, ");
    if(VDD_3132(res[2])) uart_print_text("3.1-3.2, ");
    if(VDD_3233(res[2])) uart_print_text("3.2-3.3, ");
    if(VDD_3334(res[2])) uart_print_text("3.3-3.4, ");
    if(VDD_3435(res[2])) uart_print_text("3.4-3.5, ");
    if(VDD_3536(res[2])) uart_print_text("3.5-3.6");
    uart_print_text("\r\n");
}

void SD_printR7(uint8_t *res)
{
    SD_printR1(res[0]);

    if(res[0] > 1) return;

    uart_print_text("\tCommand Version: ");
    UART_puthex8(CMD_VER(res[1]));
    uart_print_text("\r\n");

    uart_print_text("\tVoltage Accepted: ");
    if(VOL_ACC(res[3]) == VOLTAGE_ACC_27_33)
        uart_print_text("2.7-3.6V\r\n");
    else if(VOL_ACC(res[3]) == VOLTAGE_ACC_LOW)
        uart_print_text("LOW VOLTAGE\r\n");
    else if(VOL_ACC(res[3]) == VOLTAGE_ACC_RES1)
        uart_print_text("RESERVED\r\n");
    else if(VOL_ACC(res[3]) == VOLTAGE_ACC_RES2)
        uart_print_text("RESERVED\r\n");
    else
        uart_print_text("NOT DEFINED\r\n");

    uart_print_text("\tEcho: ");
    UART_puthex8(res[4]);
    uart_print_text("\r\n");
}

void SD_printCSD(uint8_t *buf)
{
    uart_print_text("CSD:\r\n");

    uart_print_text("\tCSD Structure: ");
    UART_puthex8((buf[0] & 0b11000000) >> 6);
    uart_print_text("\r\n");

    uart_print_text("\tTAAC: ");
    UART_puthex8(buf[1]);
    uart_print_text("\r\n");

    uart_print_text("\tNSAC: ");
    UART_puthex8(buf[2]);
    uart_print_text("\r\n");

    uart_print_text("\tTRAN_SPEED: ");
    UART_puthex8(buf[3]);
    uart_print_text("\r\n");

    uart_print_text("\tDevice Size: ");
    UART_puthex8(buf[7] & 0b00111111);
    UART_puthex8(buf[8]);
    UART_puthex8(buf[9]);
    uart_print_text("\r\n");
}

void SD_printBuf(uint8_t *buf)
{
    uint8_t colCount = 0;
    for(uint16_t i = 0; i < SD_BLOCK_LEN; i++)
    {
        UART_puthex8(*buf++);
        if(colCount == 19)
        {
            uart_print_text("\r\n");
            colCount = 0;
        }
        else
        {
            uart_print_char(' ');
            colCount++;
        }
    }
    uart_print_text("\r\n");
}

void SD_printDataErrToken(uint8_t token)
{
    if(token & 0xF0)
        uart_print_text("Not Error token\r\n");
    if(SD_TOKEN_OOR(token))
        uart_print_text("Data out of range\r\n");
    if(SD_TOKEN_CECC(token))
        uart_print_text("Card ECC failed\r\n");
    if(SD_TOKEN_CC(token))
        uart_print_text("CC Error\r\n");
    if(SD_TOKEN_ERROR(token))
        uart_print_text("Error\r\n");
}
