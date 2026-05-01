/***************************************************************************//**
 * (c) Copyright 2009 Actel Corporation.  All rights reserved.
 * 
 *  Atmel AT25DF641 SPI flash driver API.
 *
 * SVN $Revision:$
 * SVN $Date:$
 */

#ifndef __AT25DF641_SPI_FLASH_H_
#define __AT25DF641_SPI_FLASH_H_

#include <stdint.h>
#include <stdlib.h>

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



typedef struct __spi_flash_instance_t
{

    /* Internal transmit state: */

    uint32_t flash_size;             /*!< Size of slave transmit buffer. */
    uint32_t flash_block_size;              /*!< Current index into slave transmit buffer. */


    uint8_t  device_ID;                /*!< Pointer to buffer where data received by a slave will be stored. */
    uint8_t manufacture_ID;    /*!< Slave receive buffer siSze. */
    uint8_t device_Type;              /*!< Current index into slave receive buffer. */


} spi_flash_instance_t;


spi_flash_status_t  FLASH_init( void );


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



#endif
