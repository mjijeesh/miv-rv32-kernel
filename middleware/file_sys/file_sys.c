/*
 * spi_flash.c
 *
 *  Created on: 12-May-2023
 *      Author: jijeesh
 */

#include "file_sys.h"

#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include <middleware/delay/delay.h>
#include <middleware/stdio/uart_stdio.h>
#include "ymodem/ymodem.h"
#include "hal.h"


#include "hal/hal.h"
#include "miv_rv32_hal/miv_rv32_hal.h"

#ifdef CONFIG_USE_SPI_FLASH
#include "middleware/spi_flash/spi_flash.h"
#endif


void bx_user_code_ddr(void);    // remap to the DDR and jump to the user code
void bx_user_code_esram(void);    // remap to the DDR and jump to the user code

//#define DEBUG

#ifndef DDR_BOOT_BASE_ADDR
#define DDR_BOOT_BASE_ADDR 0xA0000000
#endif


#ifndef DDR_FILE_BASE_ADDRESS
#define DDR_FILE_BASE_ADDRESS 0xA1000000
#endif


#define ESRAM_BOOT_BASE_ADDR    0x20000000
#define ENVM_FILE_BASE_ADDR     0x6000c000
#define ENVM_FILE_SIZE          25*1024

#define ENVM_PAGE_SIZE          512

// each file will be adjusted to the sector boundary in spi flash,
#ifdef USE_SPI_FLASH_FILE_SYS
#define SECTOR_SIZE  FLASH_SECTOR_SIZE
#else
#define SECTOR_SIZE  256
#endif


/* implmented in ymodem.c */
uint32_t ymodem_download_file_ddr(uint8_t *buf, uint32_t length, file_t *file_info);
uint32_t ymodem_download_file_spi_flash(uint32_t spi_flash_address,uint32_t length,file_t *file_info);

static void boot_user_code(uint32_t reset_vector);

static void boot_user_code(uint32_t reset_vector)
{
    __asm__ volatile ("fence.i");
    __asm__ volatile("mv ra, a0");
    __asm__ volatile("ret");

        /*User application execution should now start and never return here.... */
    __builtin_unreachable();                 //This instruction never executed
}



// -------------------------------------------------------------------------------------
// SPI flash driver functions
// -------------------------------------------------------------------------------------

void load_from_ddr_boot_ddr(uint8_t index ){

  uint8_t * ddr_boot_ptr = (uint8_t *)DDR_BOOT_BASE_ADDR;

  dir_t* dir_ptr = &file_dir;;  // point to the spi_dire structure in ram

  file_t *file = &dir_ptr->files[index-1]; //  1st file is at location '0'


  uint32_t spi_addr = file->file_addr;
  uint32_t size     = file->file_size;


  /* read as many as 128 Bytes at a time ( size of the g_rd_buf buffer */
  //spi_flash_read(spi_file->file_addr, ddr_boot_ptr, spi_file->file_size);

  /* copy the file from downlaod location to boot location */
  //memcpy(file->file_ptr,ddr_boot_ptr, file->file_size );
  memcpy(ddr_boot_ptr,(uint8_t *)file->file_addr, file->file_size );

  PRINT_TEXT("\r\nStarting execution from DDR memory ....:");

  boot_user_code(DDR_BOOT_BASE_ADDR);  // jump to the ddr location and execute
}


void load_from_spiflash_boot_ddr(uint8_t index ){

  uint8_t * ddr_boot_ptr = (uint8_t *)DDR_BOOT_BASE_ADDR;

  /* use dir_t and file_t for spi file system*/

  dir_t* dir_ptr = &file_dir;;  // point to the file system directory

  file_t *file = &dir_ptr->files[index-1]; //  1st file is at location '0'



  /* copy the file from download location to boot location */

  spi_flash_read_file(file->file_addr, ddr_boot_ptr, file->file_size);
  PRINT_TEXT("\r\nStarting execution from DDR memory ....:");
  delay_ms(500);

  boot_user_code(DDR_BOOT_BASE_ADDR);  // jump to the ddr location and execute
}



/* copy the eSRAM executable image to the eSRAM location 0x20000000 and
 * execute from there */

void load_from_spiflash_boot_ram(uint8_t index , uint32_t boot_addr){

	uint8_t * ram_boot_ptr = (uint8_t *)boot_addr;

  /* use dir_t and file_t for spi file system*/

	dir_t* dir_ptr = &file_dir;;  // point to the spi_dire structure in ram

  file_t *file = &dir_ptr->files[index-1]; //  1st file is at location '0'
  /* copy the file from downlaod location to boot location */

  spi_flash_read_file(file->file_addr, ram_boot_ptr, file->file_size);

  PRINT_TEXT("\r\nFile copy completed ....:");

  boot_user_code(boot_addr);  //  jump to the ddr location and execute
}



void load_from_ddr_boot_esram(uint8_t index ){

  uint8_t * esram_boot_ptr = (uint8_t *)ESRAM_BOOT_BASE_ADDR;

  dir_t* dir_ptr = &file_dir;;  // point to the spi_dire structure in ram

  file_t *file = &dir_ptr->files[index-1]; //  1st file is at location '0'


  /* copy the file from downlaod location to boot location */
  memcpy(esram_boot_ptr,(uint8_t *)file->file_addr, file->file_size );


  PRINT_TEXT("\r\nStarting execution from eSRAM memory ....:");

  delay_ms(500);

  /* Turn off the SYSTICK */
  //SysTick->CTRL = 0x00 ;
  //__disable_irq();

  boot_user_code(ESRAM_BOOT_BASE_ADDR);


}





/***************************************************************************
 *
 *
 * @param index : File index i nthe directory structure.
 * @param esram_dst_addr : Destination ram address ( ram/ddr/esram etc)
 */

  void copy_file_spiflash_to_ram(uint8_t index ,uint32_t dest_addr){

      uint8_t * ram_file_ptr = (uint8_t *)dest_addr;

        /* use dir_t and file_t for spi file system*/
      dir_t* dir_ptr = &file_dir;;  // point to the spi_directory structure in ram
      file_t *file_ptr  =  &dir_ptr->files[index-1]; //  1st file is at location '0'

        /* copy the file from download location to destination location */

        spi_flash_read_file(file_ptr->file_addr, ram_file_ptr, file_ptr->file_size);

       PRINT_TEXT("\r\nFile copy completed ....:");

}


  /****************************************
   *
   * return the adress of the file from the directory list
   * @param index  : File index
   * @return
   ***************************************/

uint32_t get_file_addr(uint8_t index)
    {

        /* use dir_t and file_t for spi file system*/

      dir_t* dir_ptr = &file_dir;  // point to the spi_dire structure in ram

       file_t *file_ptr = &dir_ptr->files[index-1]; //  1st file is at location '0'

       return  file_ptr->file_addr;  // return the address of the file

    }

/**************************************************
 * print the current directory structure, and user can key in an index
 * @return the file index
 ***************************************************/
uint8_t get_file_index(void) {

    uint8_t key,file_index ;

    print_dir();
    PRINT_TEXT("\r\nEnter the File index :");
    key = uart_getchar();
    uart_putc(key);

    file_index = key - '0';  // Subtract '0' to get the integer value

    return file_index;

  }



/*####################################################################
   *
   *  This function will check for an existing file system available in SPI flash/RAM
   *  If not active and availabl,e the new file system ( directory structure) will be created
   *  If the file system is already available, the existing file structure will be loaded     *
   *
   *####################################################################*/


  void init_file_sys (void){

       uint8_t buffer[sizeof(dir_t)];

       dir_t* dir_ptr = &file_dir;

        printf("\n\rChecking the SPI File System Status...");

            #ifdef USE_SPI_FLASH_FILE_SYS
             FLASH_read(SPI_DIR_ROOT_ADDR, buffer, sizeof(dir_t));
             memcpy(dir_ptr, buffer, sizeof(dir_t)); // Load the buffer into the global spi_dir
            #endif

         if ( dir_ptr->init_status != 0xAA55AA33){

             memset(buffer, 0x00, sizeof(dir_t));  // Clear the directory structure

             printf("\r\nSPI Directory not initialised....");
             // Set the initialization status
              dir_ptr->init_status = 0xAA55AA33;

              dir_ptr->file_count = 0;
              dir_ptr->next_addr = SPI_FILE_ROOT_ADDR; // file storage start address


              //update the spi flash with new modifications
                #ifdef USE_SPI_FLASH_FILE_SYS
                 /* update the spi flash  directory_structure with  new modifications */
                 spi_flash_write_file(SPI_DIR_ROOT_ADDR, (uint8_t *)dir_ptr, sizeof(dir_t));

                #endif

              printf("\r\nSPI File System Created....");


         } else

         {

             printf("\r\nSPI File System is Available and Loaded....");

         }
    }


  /*####################################################################
   *
   *  Delete teh existing file structe and  create a new one.
   *
   *####################################################################*/


  void clear_file_sys (void){

      dir_t* dir_ptr = &file_dir;

        printf ("\r\nInitialising the SPI Flash File System......");
       // FLASH_chip_erase();
       // delay_ms(500);

       /* Clear the SPI directory structure in memory */
       memset(dir_ptr, 0x00, sizeof(dir_t));

       /* Set the initialization status */
          dir_ptr->init_status = 0xAA55AA33;

          dir_ptr->file_count = 0;
          dir_ptr->next_addr = SPI_FILE_ROOT_ADDR; // file storage start address


        #ifdef USE_SPI_FLASH_FILE_SYS
         /* update the spi flash  directory_structure with  new modifications */
         spi_flash_write_file(SPI_DIR_ROOT_ADDR, (uint8_t *)dir_ptr, sizeof(dir_t));

        #endif

        printf("\r\nSPI File System Re-Created....");



    }



  /*####################################################################
   *     *
   * This functions displays the content of the file in hex view format.
   *
   * @param index  : The file index in the file system
   *####################################################################*/

  void print_file(uint8_t index ){

        dir_t* dir_ptr = &file_dir;;  // point to the spi_dire structure in ram

        file_t *file_ptr = &dir_ptr->files[index-1]; //  1st file is at location '0'

        PRINT_TEXT("\r\nFile Details:");

        printf("\r| %-30s | %10.2fkb | 0x%-12X |\n",
                file_ptr->file_name,
                file_ptr->file_size / 1024.0,
                file_ptr->file_addr);

        #ifdef USE_SPI_FLASH_FILE_SYS
        hex_view_spi_flash(file_ptr->file_addr, file_ptr->file_size);
        #else
        hex_view_buffer( file_ptr->file_size ,0, file_ptr->file_size);
        #endif

    }

      /**************************************************************************
       *     *
       * This functions download the file using ymodem protocol into the spiflash/ram location
       * the new file location will be decided by the filesystem next_addr
       *
       * @param index  : The file index in the file system
       ***************************************************************************/

  uint32_t file_download(void)
   {
       uint32_t file_size;
       file_t   file_info ;
       uint32_t  offset_addr;
       dir_t* dir_ptr = &file_dir;

       PRINT_TEXT( "\r\n------------------------ Ymodem app ----------\r\n" );

        uint32_t MAX_FILE_SIZE = 8*1024 * 1024 * 8; // maximum size of the file to download  is set to  8MB


        offset_addr = dir_ptr->next_addr;  //get the new file store location

        PRINT_TEXT( "\r\n------------------------ Ymodem app2 ----------\r\n" );
        /* Configure systick timer for interrupt at 10msec intervals */
        MRV_systick_config(SYS_CLK_FREQ/100);

         PRINT_TEXT( "\r\n------------------------ Ymodem app3 ----------\r\n" );

        #ifdef USE_SPI_FLASH_FILE_SYS
        PRINT_TEXT( "\r\n------------------------ Starting YModem file transfer to SPI Flash Memory----------\r\n" );
        PRINT_TEXT( "Please select file and initiate transfer on host computer.\r\n" );

        file_size = ymodem_download_file_spi_flash(offset_addr, MAX_FILE_SIZE, &file_info);
        #else
        PRINT_TEXT( "\r\n------------------------ Starting YModem file transfer to ram/ddr Memory----------\r\n" );
        PRINT_TEXT( "Please select file and initiate transfer on host computer.\r\n" );
        file_size = ymodem_download_file_ddr( (uint8_t *)offset_addr, MAX_FILE_SIZE, &file_info);

        #endif



       if (file_size > 0)
            {
           print_file_info(&file_info);  // print the received file information
           add_file_to_dir(&file_info);  // add the file information to directory structure
            }
       else {
               PRINT_TEXT("No File received: \n");
           }
       return file_size;

   }


  /**************************************************************************
   *
   * Add the received fiel into the file system. and provide the next file storage address     *
   *
   * @param file_info  : The recieved fiel info structure
   ***************************************************************************/

   int add_file_to_dir(file_t* file_info) {
        uint32_t next_addr ;

        dir_t* dir_ptr = &file_dir;

        // Find the first empty slot or calculate the start address for the new file
        for (uint8_t i = 0; i < MAX_FILES; i++)
            {
                file_t *file_ptr = &dir_ptr->files[i]; // Pointer to the current file

                if (file_ptr->file_name[0] == '\0')
                    {
                    // Empty entry found, use this slot for the new file entry
                      strncpy(file_ptr->file_name, file_info->file_name, sizeof(file_ptr->file_name) - 1);
                      file_ptr->file_name[sizeof(file_ptr->file_name) - 1] = '\0';  // Ensure null-termination
                      file_ptr->file_size = file_info->file_size;
                      file_ptr->file_addr = file_info->file_addr; // update the current file addr with the value from dir entry

                      dir_ptr->file_count++;  // Increment the file count in the directory

                      next_addr = (file_ptr->file_addr + file_ptr->file_size  + SECTOR_SIZE - 1) & ~(SECTOR_SIZE - 1);
                      dir_ptr->next_addr = next_addr; // this is the addr for next file

                      #ifdef USE_SPI_FLASH_FILE_SYS
                         /* update the spi flash  directory_structure with  new modifications */
                         spi_flash_write_file(SPI_DIR_ROOT_ADDR, (uint8_t *)dir_ptr, sizeof(dir_t));

                      #endif

                      return 0;  // Success
                   }
            }

        return -1;  // No empty slot available
    }



    /***************************************************************************   *
    *
    * @param file_info : The file pointer  the information needs to be displayed
    ***************************************************************************/

   void print_file_info(file_t *file_info)
     {

            printf("\r%-30s %10u  0x%-8X\n", file_info->file_name, file_info->file_size, (uint32_t)(file_info->file_addr));


     }

   /***************************************************************************
    * This function print the current file system directory contents
    *
    * @param file_info :
    ***************************************************************************/


   void print_dir(void) {

       dir_t* dir_ptr = &file_dir;

        printf("\r\nSPI Flash Directory:\n");

        printf("\rSPI Flash File Count : %d\n",      dir_ptr->file_count);
        printf("\rSPI Flash Next Addr  : 0x%-12X\n", dir_ptr->next_addr);
        printf("\rSPI Flash init flag  : 0x%-12X\n", dir_ptr->init_status);

        printf("\r----------------------------------------------------------------------------\n");
        printf("\r| %-4s | %-34s | %-10s | %-12s |\n", "#", "File Name", "Size(Bytes)", "Addr Offset");
        printf("\r----------------------------------------------------------------------------\n");

        for (int i = 0; i < dir_ptr->file_count; i++) {
            file_t *file_ptr = &dir_ptr->files[i];  // Pointer to the current file
            if (file_ptr->file_name[0] != '\0') {       // Check if entry is valid
                printf("\r| %-4d | %-34s  |  %8dB| 0x%-10X |\n",
                       i + 1,
                       file_ptr->file_name,
                       file_ptr->file_size,
                       file_ptr->file_addr);
            }
        }
        printf("\r----------------------------------------------------------------------------\n");
    }




