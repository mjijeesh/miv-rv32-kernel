/*
 * spi_flash.c
 *
 *  Created on: 12-May-2023
 *      Author: jijeesh
 */

#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include <middleware/delay/delay.h>
#include <middleware/spi_flash/spi_flash.h>
#include <middleware/stdio/uart_stdio.h>
#include "drivers/fpga_ip/CoreSPI/core_spi.h"
#include "miv_rv32_hal/miv_rv32_hal.h"


#include "spi_flash.h"


extern spi_instance_t * g_spi_0;

//#define SPI_FLASH_CS  SPI_SLAVE_0

#define  spi_trans(a)    SPI_transfer_frame( g_spi_0, a)
#define  spi_cs_en(ss)   SPI_set_slave_select(g_spi_0, ss)
#define  spi_cs_dis(ss)  SPI_clear_slave_select(g_spi_0, ss)







/**********************************************************************//**
 *  Write the entire file to the SPI Flash memory
 *  The file needs to be stored in a memory location , either SRAM or the DDR space.
 *   *
 * @param[in] addr    :  target spi location .
 * @param[in] buffer  :  uint8_t pointer to the buffer where file is kept.
 * @param[in] size    :  size of the image to be written in bytes
 **************************************************************************/



/*******************************************************************************
 *
 */
int spi_flash_init( void )
{
    uint8_t  manufacturer_id,device_id;
    PRINT_TEXT("\r\nConfiguring the SPI Flash....");
    FLASH_init();
    FLASH_read_device_id(&manufacturer_id,&device_id);
    PRINT_TEXT("\r\nFound SPI Flash ....");
    PRINT_TEXT("\r\nDevice ID    :");
    PRINT_XNUM(device_id);
    PRINT_TEXT("\r\nManfactureID :");
    PRINT_XNUM(manufacturer_id);
    PRINT_TEXT("\r\nSPI Flash Configuration -------OK");

}



void spi_flash_write_file ( uint32_t addr, uint8_t *  buffer, uint32_t size){

     uint32_t i,numb_4k_sectors;
     uint32_t  sector_addr =  addr;

     /* erase at least 1 sector */
     numb_4k_sectors = (size / (FLASH_SECTOR_SIZE)) + 1;

    /* disable the protection bit if not done already */
     FLASH_global_unprotect();

   /* this function uses the 4k block erase command,
    * you can also use the 64K sector erase command as well */

  for (i= 0 ; i < numb_4k_sectors ; i++ ){

     FLASH_erase_4k_block(sector_addr);
    /* added a delay to make sure that the erase is completed */
     delay_ms(50);
    sector_addr += FLASH_SECTOR_SIZE;
  }
  /* program the file to the location specified */
  FLASH_program(addr, buffer, size);
  PRINT_TEXT("\r\n Writing File Completed\r\n");

}





/**********************************************************************//**
 * Write data into a single sector.
 * This is a helper function for the demo.
 * keep the data ready in g_flash_wr_buf for writing
 * @param[in] addr  :  flash memory address location  uint32_t
 * @return Read byte from SPI flash.
 **************************************************************************/
void spi_flash_write_sector (uint32_t addr , uint8_t * write_buff , uint32_t size)
{

    FLASH_global_unprotect();

    PRINT_TEXT("\r\n Erasing Sector @ " );
    PRINT_XNUM(addr);

    FLASH_erase_4k_block(addr);

    FLASH_program(addr, write_buff, size);
    PRINT_TEXT("\r\nProgramming Completed \r\n :");

}

/**********************************************************************//**
 * erase multiple sector of the flsh memory
 * This is a helper function for the demo.
 * keep the data ready in g_flash_wr_buf for writing
 * @param[in] addr    :  flash memory  start location address  uint32_t
 * * @param[in] size  :   total size of the location to be erased in bytes
 * @return Read byte from SPI flash.
 **************************************************************************/



void spi_flash_erase_sectors(uint32_t addr, uint32_t size){

     uint32_t i,numb_4k_sectors;

     uint32_t  sector_addr = addr;

     numb_4k_sectors = (size / (FLASH_SECTOR_SIZE)) + 1;
     PRINT_TEXT("\r\n Number of sectors to be erased :  " );
     PRINT_DNUM(numb_4k_sectors);

     FLASH_global_unprotect();

  for (i= 0 ; i < numb_4k_sectors ; i++ ){
     PRINT_TEXT("\r\n Erasing Sector @ " );
    PRINT_XNUM(sector_addr);

    FLASH_erase_4k_block(addr);

    PRINT_TEXT("\r\n Erasing Completed \r\n :");
    delay_ms(500);
    sector_addr += FLASH_SECTOR_SIZE;
  }


}

/**********************************************************************//**
 * print spi flash device info.
 * This is a helper function for the demo.

 **************************************************************************/

void spi_flash_device_info(void){

    uint8_t idcode;
    uint8_t device_id;

    FLASH_read_device_id(&idcode, &device_id);
    PRINT_TEXT(" \r\nIdcode : ");
    print_hex_byte(idcode);
    PRINT_TEXT(" , Device ID  : ");
    print_hex_byte(device_id);
}



/***************************************************************************//**
 * Read the date from SPI FLASH and compare the same with write buffer.
 */
 uint8_t spi_flash_verify_write(uint8_t* write_buff, uint8_t* read_buff, uint32_t spi_addr,  uint16_t size)
{
    uint8_t error = 0;
    uint16_t index = 0;

    FLASH_read(spi_addr,read_buff,size);

    while(size != 0)
    {
        if(write_buff[index] != read_buff[index])
        {
            error++;
           // break;  ideally we need to break whenever a error occured
        }
        index++;
        size--;
    }

    return error;
}





  /**********************************************************************//**
     * This function is used to initialise the read and write buffers
     * for the spi flash demo usage..
     * This is a helper function for the demo.

     **************************************************************************/


///////////////////////////////////////////////////////////////////////////////////////////////////////////////


