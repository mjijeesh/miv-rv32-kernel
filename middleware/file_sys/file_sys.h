/*
 * file_sys.h
 *
 *  Created on: Nov 5, 2024
 *      Author: jijeesh
 */

#ifndef APPLICATION_CM3_MSS_UART_YMODEM_DEMO_FILE_SYS_H_
#define APPLICATION_CM3_MSS_UART_YMODEM_DEMO_FILE_SYS_H_
#include "hal.h"

#define MAX_FILES 15
#define FILE_NAME_LENGTH (64)
#define FILE_SIZE_LENGTH (16)



/* ---- SPI configuration ---- */

#define VALID_KEY  0xAA55AA55

#ifdef USE_SPI_FLASH_FILE_SYS

#define SPI_DIR_ROOT_ADDR   (0x00000000 + 0x1000)           // sector 1
#define SPI_FILE_ROOT_ADDR  (SPI_DIR_ROOT_ADDR + 0x4000)  // sector 5 onwards

#endif


typedef struct {
    uint8_t     file_name[FILE_NAME_LENGTH];           // File name (max 32 characters)
    uint8_t     size[FILE_SIZE_LENGTH];          // file size in string
    uint32_t    file_size;       // file size in bytes
    uint32_t    file_addr;       // addr offset in spi flash memory
    uint8_t     *file_ptr;       // Pointer to the file in DDR memory
    uint32_t    checksum;        // file checksum
} file_t;



typedef struct {
    uint32_t   init_status;        // Number of files currently stored
    uint8_t    file_count;        // Number of files currently stored
    uint32_t   next_addr;        // next available addr for new file
    file_t files[MAX_FILES];   // Array of files

} dir_t;



dir_t file_dir;





uint32_t ddr_file_download(void);
void file_sys_init (uint8_t * file_ptr);
void load_from_ddr_boot_esram(uint8_t index );
void load_from_ddr_boot_ddr(uint8_t index );
void load_from_spiflash_boot_ddr(uint8_t index );
void load_from_spiflash_boot_esram(uint8_t index );
void load_from_envm_boot_esram(uint32_t envm_src_addr );
void copy_from_spiflash_to_envm(uint8_t index , uint32_t envm_dst_addr );
void copy_from_spiflash_to_esram(uint8_t index ,uint32_t esram_dst_addr);

void copy_file_spiflash_to_ram(uint8_t index ,uint32_t dest_addr);






void print_dir(void) ;

void print_file_info(file_t *file_info);
void print_file(uint8_t index );


void init_file_sys (void);
void clear_file_sys (void);

uint32_t file_download(void);
int add_file_to_dir(file_t* file_info);

void clear_file_sys (void);
void init_file_sys (void);

uint32_t get_file_addr(uint8_t index);
uint8_t  get_file_index(void);






#endif /* APPLICATION_CM3_MSS_UART_YMODEM_DEMO_FILE_SYS_H_ */
