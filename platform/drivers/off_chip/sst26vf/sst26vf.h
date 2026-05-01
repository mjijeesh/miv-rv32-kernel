/***************************************************************************//**
 * (c) Copyright 2009 Actel Corporation.  All rights reserved.
 * 
 *  MICRON_1G_SPI_FLASH_ SPI flash driver API.
 *
 * SVN $Revision:$
 * SVN $Date:$
 */

#ifndef __MICRON_1G_SPI_FLASH_H_
#define __MICRON_1G_SPI_FLASH_H_

#include <stdint.h>
#include <stdlib.h>

/* Manufacture and device IDs for Microchip SST26VF064B SPI Flash. */
#define MCHP_FLASH_MANUFACTURER_ID   (uint8_t)0xBF
#define MCHP_FLASH_DEVICE_ID         (uint8_t)0x43
#define MCHP_FLASH_DEVICE_TYPE       (uint8_t)0x26

#define DIE_ERASE_0_256MB 0
#define DIE_ERASE_256MB_512MB 1
#define DIE_ERASE_512MB_768MB 2
#define DIE_ERASE_768MB_1GB 3

#define ERASE_4K_BLOCK  0
#define ERASE_64K_BLOCK  1

#define FLASH_SECTOR_SIZE 4096




/*******************************************************************************
 * Possible return values from functions on SPI FLASH.
 ******************************************************************************/
typedef enum {
    SPI_FLASH_SUCCESS = 0,
    SPI_FLASH_PROTECTION_ERROR,
    SPI_FLASH_WRITE_ERROR,
    SPI_FLASH_INVALID_ARGUMENTS,
    SPI_FLASH_INVALID_ADDRESS,
    SPI_FLASH_UNSUCCESS
} spi_flash_status_t;

/*******************************************************************************
 * Possible HW Control commands on SPI FLASH.
 ******************************************************************************/
typedef enum {
    SPI_FLASH_SECTOR_UNPROTECT = 0,
    SPI_FLASH_SECTOR_PROTECT,
    SPI_FLASH_GLOBAL_UNPROTECT,
    SPI_FLASH_GLOBAL_PROTECT,
    SPI_FLASH_GET_STATUS,
    SPI_FLASH_4KBLOCK_ERASE,
    SPI_FLASH_32KBLOCK_ERASE,
    SPI_FLASH_64KBLOCK_ERASE,
    SPI_FLASH_CHIP_ERASE,
    SPI_FLASH_READ_DEVICE_ID,
    SPI_FLASH_RESET
/*
    SPI_FLASH_SECTOR_LOCKDOWN,
    SPI_FLASH_FREEZE_SECTOR_LOCKDOWN
*/
} spi_flash_control_hw_t;

struct device_Info{
    uint8_t manufacturer_id;
    uint8_t device_id;
};



spi_flash_status_t FLASH_init( void );

spi_flash_status_t FLASH_read_device_id
(
    uint8_t * manufacturer_id,
    uint8_t * device_id
);

spi_flash_status_t FLASH_read
(
    uint32_t address,
    uint8_t * rx_buffer,
    size_t size_in_bytes
);

spi_flash_status_t FLASH_global_unprotect( void );

spi_flash_status_t FLASH_chip_erase( void );

spi_flash_status_t FLASH_erase_64k_block
(
    uint32_t address
);

spi_flash_status_t FLASH_erase_4k_block
(
    uint32_t address
);

spi_flash_status_t FLASH_get_status( void );

spi_flash_status_t FLASH_program
(
    uint32_t address,
    uint8_t * write_buffer,
    size_t size_in_bytes
);




spi_flash_status_t sst26vf_spi_flash_init ( void);
spi_flash_status_t flash_init( void );

spi_flash_status_t spi_flash_read_device_id
(
    uint8_t * manufacturer_id,
    uint8_t * device_id
);

spi_flash_status_t spi_flash_read
(
    uint32_t address,
    uint8_t * rx_buffer,
    size_t size_in_bytes
);

spi_flash_status_t spi_flash_global_unprotect( void );
/* call this function 4 times as follows to erase the entire chip
 * FLASH_die_256MB_erase(DIE_ERASE_0_256MB);
 * FLASH_die_256MB_erase(DIE_ERASE_256MB_512MB)
 * FLASH_die_256MB_erase(DIE_ERASE_512MB_768MB)
 * FLASH_die_256MB_erase(DIE_ERASE_768MB_1GB)
 *
 *  */
void FLASH_die_256MB_erase( uint8_t );
spi_flash_status_t spi_flash_chip_erase (void);
void FLASH_erase_xk_block
(
    uint32_t address , uint8_t xk_block
);


spi_flash_status_t spi_flash_write
(
    uint32_t address,
    uint8_t * write_buffer,
    size_t size_in_bytes
);
spi_flash_status_t spi_flash_erase_64k_block
(
    uint32_t address
);

spi_flash_status_t spi_flash_erase_4k_block
(
    uint32_t address
);


#endif
