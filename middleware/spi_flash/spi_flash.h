/*
 * spi_flash.h
 *
 *  Created on: 12-May-2023
 *      Author: jijeesh
 */

#ifndef MIDDLEWARE_SPI_FLASH_SPI_FLASH_H_
#define MIDDLEWARE_SPI_FLASH_SPI_FLASH_H_

#include "hal.h"
#include "ymodem/ymodem.h"
//#include "file_sys/file_sys.h"

//#define CONFIG_FLASH_MICROCHIP_SST26VF 1


#ifdef CONFIG_SPI_FLASH_MICROCHIP_SST26VF
#include "drivers/off_chip/microchip_sst26vf/sst26vf.h"
#elif defined(CONFIG_SPI_FLASH_SPANSION_S25FL128S)
#include "drivers/off_chip/spansion/s25fl128s.h"
#elif defined(CONFIG_SPI_FLASH_MICROCHIP_SST26VF)
#include "drivers/off_chip/sst26vf/sst26vf.h"
#elif defined(CONFIG_SPI_FLASH_WINBOND_W25Q)
#include "drivers/off_chip/w25q64fvssig/w25q64fvssig.h"
#elif defined(CONFIG_SPI_FLASH_MICRON_MT25QL01GBBB)
#include "drivers/off_chip/mt25ql01gbbb/mt25ql01gbbb.h"
#endif





void spi_flash_write_sector (uint32_t addr , uint8_t * write_buff , uint32_t size);

int spi_flash_init( void );

void bx_user_code_ddr(void);    // remap to the DDR and jump to the user code

//void spi_flash_read_file (uint32_t addr , uint8_t *  rd_buffer ,uint32_t size );
void spi_flash_write_file ( uint32_t addr, uint8_t *  buffer, uint32_t size);
void spi_flash_read_old(uint32_t addr , uint8_t *  rd_buffer ,uint32_t size );

void spi_flash_erase_sectors(uint32_t addr, uint32_t size);
void spi_flash_device_info();
void spi_demo_init_buffers (void);

uint8_t spi_flash_verify_write(uint8_t* write_buff, uint8_t* read_buff, uint32_t spi_addr,  uint16_t size);

int  boot_from_spi_flash(void);
void load_from_spi_flash_boot_ddr(uint8_t index );
void load_from_spi_flash_boot_esram(uint8_t index );

#ifndef  SPI_EN
#define SPI_EN 1
#endif

/**********************************************************************//**
 * SPI flash commands
 **************************************************************************/
enum SPI_FLASH_CMD {
  SPI_FLASH_CMD_PAGE_PROGRAM = 0x02, /**< Program page */
  SPI_FLASH_CMD_READ         = 0x03, /**< Read data */
  SPI_FLASH_CMD_READ_STATUS  = 0x05, /**< Get status register */
  SPI_FLASH_CMD_WRITE_ENABLE = 0x06, /**< Allow write access */
  SPI_FLASH_CMD_READ_ID      = 0x9F, /**< Read manufacturer ID  modified by Jm for SST flash, original value 0x9E*/
  SPI_FLASH_CMD_SECTOR_ERASE = 0xD8,  /**< Erase complete sector */
  ERASE_4K_BLOCK_OPCODE      = 0x20, /* Erase 4k block */
  WRITE_STATUS_REG           = 0x01,
  GLOBAL_UNPROTECT_OPCODE    = 0x98
};




void spi_demo_init_buffers (void);


#define spi_flash_read(addr, buff, size)         FLASH_read(addr, buff, size);
#define spi_flash_erase_4k_block(address)        FLASH_erase_4k_block(address);
#define spi_flash_write(addr, buff, size)        FLASH_program(addr, buff, size);

#define spi_flash_read_file(addr,rd_buffer,size) FLASH_read(addr, rd_buffer, size);

void spi_demo_init_buffers (void);





#endif /* MIDDLEWARE_SPI_FLASH_SPI_FLASH_H_ */
