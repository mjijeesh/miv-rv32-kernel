## CoreSPi SPI Flash Demo
---------------------------

This example shows how to read/write SPI flash memory

reading and writing into spi flash memory from internal ddr ram.
individual sector write and sector erase also implmented.

use the help menu in the application for more info




## Config Switches

*Driver Selections*

```
CONFIG_USE_CORE_GPIO     = Y
CONFIG_USE_CORE_UART     = Y
CONFIG_USE_CORE_TIMER    = Y
CONFIG_USE_CORE_SPI      = Y


```


*Middleware Selections*

```
CONFIG_USE_SYSTICK_DELAY        = Y
CONFIG_USE_CORE_UART_PRINT      = Y
CONFIG_USE_SPI_FLASH            = Y

```

`CONFIG_USE_SYSTICK_DELAY`  enables the use of `delay_ms()` .
This is implmented in the `middleware/delay.c` file
Note: initilise the delay library using the `CONFIG_Delay_init()` before using the `delay_m()` function


`CONFIG_USE_CORE_UART_PRINT` enables the additional formatted printing functions like `hex_view_print()`
This function prints a buffer . The implmentation is done in the  `middleware/stdio/uart_stdio.c` file.
This provides functions like
  - `PRINT_TEXT()`
  - `PRINT_XNUM(0)`
  - `PRINT_DNUM()`
  - `hex_view_buffer()`  : print the array in hex format


   
  `CONFIG_USE_SPI_FLASH`  enables the spi flash functions. Thisi s implmented in `middleware/spi_flash/spi_flash.c`  This file provides the below functions
  
  - `spi flash read`
  - 'spi flash write`
  - `spi_read_idcode`
  - 
  
  The individual flash driver is provided in the `drivers/off_chip/` folder.
  Select the flash device in the `board/fpga_design_config.h`

  used in the board is provided under drivers/off_chip/flashdriver directory.
  The selection of the driver file is done using the  -D switch provided in the Makefile in board folder.
  
  following -D defenision are created based o nthe board used.
  ```  
  #ifdef CONFIG_SPI_FLASH_MICROCHIP_SST26VF
  #include "drivers/off_chip/sst26vf/sst26vf.h"
  #elif defined(CONFIG_SPI_FLASH_SPANSION_S25FL128S)
  #include "drivers/off_chip/spansion/s25fl128s.h"
  #elif defined(CONFIG_SPI_FLASH_MICROCHIP_SST26VF)
  #include "drivers/off_chip/sst26vf/sst26vf.h"
  #elif defined(CONFIG_SPI_FLASH_WINBOND_W25Q)
  #include "drivers/off_chip/w25q64fvssig/w25q64fvssig.h"
  #elif defined(CONFIG_SPI_FLASH_MICRON_MT25QL01GBBB)
  ```


## Run the Demo


###  Start `OPENOCD` server

```bash

$ make openocd 

------OPENOCD CONFIGURATION--------
OPENOCDCMD      = openocd
TARGET_CFG      = board/microsemi-riscv.cfg
OPENOCD_ARGS    = gdb_port 3333 ; telnet_port 4444 ; tcl_port 6666 ; adapter_khz 1000 ;

xPack OpenOCD (Microchip SoftConsole build), x86_64 Open On-Chip Debugger 0.10.0+dev-00859-g95a8cd9b5-dirty (2022-03-15-14:04)
Licensed under GNU GPL v2
For bug reports, read
	http://openocd.org/doc/doxygen/bugs.html
Info : only one transport option; autoselect 'jtag'
fpServer v17 waiting for incoming connections on the port 3334 with API v5
do_board_reset_init
adapter speed: 1000 kHz

Info : Listening on port 6666 for tcl connections
Info : Listening on port 4444 for telnet connections
Info : No Embedded FlashPro6 (revision B) devices found
Device not found
Info : 1 1777455920836 microsemi_flashpro_server.c:1751 microsemi_flashpro_initialize() FlashPro ports available: E200108CTE
Info : 2 1777455920836 microsemi_flashpro_server.c:1752 microsemi_flashpro_initialize() FlashPro port selected:   E200108CTE
Device not found
Device not found
Info : clock speed 1000 kHz
Info : JTAG tap: fpga.tap tap/device found: 0x2f8041cf (mfg: 0x0e7 (GateField), part: 0xf804, ver: 0x2)
Info : JTAG tap: fpga.tap disabled
Info : JTAG tap: fpga.cpu enabled
Info : RISC-V IDCODE = 0x4e50105f
Info : datacount=1 progbufsize=0
Warn : We won't be able to execute fence instructions on this target. Memory may not always appear consistent. (progbufsize=0, impebreak=0)
Info : Examined RISC-V core; found 1 harts
Info :  hart 0: XLEN=32, misa=0x42001104
Info : Listening on port 3333 for gdb connections
Info : accepting 'gdb' connection on tcp/3333


```

### build the Application

build the application  using the below command `clean_all` or `clean all` . The `debug` switch launches the `gdb` debuger once the build is finished. make sure that the `openocd` server is already running



```sh
 $make run_all debug  TARGET=rv32-spiflash BOARD=m2s-creative-brd

 ```

 ```


 SPIFLASH = MICROCHIP_SST26VF Selected

---------------- BOARD CONFIGURATION ----------------

TARGET BOARD    = m2s-creative-brd
DEVICE          = M2S025-VF256
LINKER          = boards/m2s-creative-brd/platform_config/linker/miv-rv32-ram.ld
APP_NAME        = rv32-spiflash
STDIO           = MSCC_STDIO_THRU_CORE_UART_APB

---------------- Driver & Middleware Status ----------------

CORE_TIMER       = [ENABLED]
CORE_UART        = [ENABLED]
CORE_GPIO        = [ENABLED]
CORE_SPI         = [ENABLED]
-------------------------------------------------------
USER_FLAGS      = -D MSCC_STDIO_THRU_CORE_UART_APB -D CONFIG_SPI_FLASH_MICROCHIP_SST26VF
-------------------------------------------------------
SPI FLASH Memory Used
TIMER_DELAY  = Y   Selected
OPTIMIZATION  = -O0
DEBUG LEVEL   = -g3
DIRS          = -I platform/drivers/fpga_ip/CoreUARTapb -I platform/drivers/fpga_ip -I middleware/spi_flash    -I middleware/delay -I middleware/stdio -I middleware -I platform -I platform/hal -I application/rv32-spiflash -I . -I application -I middleware -I platform -I platform/drivers/off_chip/microchip_sst26vf -I platform/drivers/fpga_ip/CoreTimer -I platform/drivers/fpga_ip/CoreGPIO -I platform/drivers/fpga_ip/CoreSPI -I boards/m2s-creative-brd -I boards/m2s-creative-brd/drivers_config/sys_config -I boards/m2s-creative-brd/fpga_design_config
SRCS          = platform/hal/hal_irq.c platform/miv_rv32_hal/miv_rv32_hal.c platform/miv_rv32_hal/miv_rv32_init.c platform/miv_rv32_hal/miv_rv32_stubs.c platform/miv_rv32_hal/miv_rv32_syscall.c application/rv32-spiflash/src/main.c  application/rv32-spiflash/src/hw_init.c  platform/drivers/off_chip/microchip_sst26vf/sst26vf.c platform/drivers/fpga_ip/CoreTimer/core_timer.c platform/drivers/fpga_ip/CoreUARTapb/core_uart_apb.c platform/drivers/fpga_ip/CoreGPIO/core_gpio.c platform/drivers/fpga_ip/CoreSPI/core_spi.c middleware/spi_flash/spi_flash.c middleware/delay/timer_delay.c middleware/stdio/uart_stdio.c
USER_FLAGS    = -D MSCC_STDIO_THRU_CORE_UART_APB -D CONFIG_SPI_FLASH_MICROCHIP_SST26VF -D USE_SPI_FLASH_FILE_SYS -D CONFIG_USE_SPI_FLASH -D USE_TIMER_DELAY -D CORE_UART_PRINT -D MSCC_NO_RELATIVE_PATHS
CFLAGS        = -march=rv32i -mabi=ilp32 -g3 -O0 -std=gnu11 --specs=nano.specs -mcmodel=medany  -msmall-data-limit=8   -mstrict-align -mno-save-restore  -fmessage-length=0 -fsigned-char -fdata-sections -ffunction-sections 
LDFLAGS       = -march=rv32i -mabi=ilp32 -g3 -O0 -mcmodel=medany -msmall-data-limit=8 -mstrict-align -mno-save-restore  -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -Tboards/m2s-creative-brd/platform_config/linker/miv-rv32-ram.ld  -Xlinker --gc-sections -nostartfiles --specs=nano.specs 
ASM_FLAGS     = -march=rv32i -mabi=ilp32 -O0  -g3 -x assembler-with-cpp -mcmodel=medany  -msmall-data-limit=8 -mstrict-align -mno-save-restore  -fmessage-length=0 -fsigned-char -fdata-sections -ffunction-sections 

 CC        application/rv32-spiflash/build/platform/hal/hal_irq.o
 CC        application/rv32-spiflash/build/platform/miv_rv32_hal/miv_rv32_hal.o
 CC        application/rv32-spiflash/build/platform/miv_rv32_hal/miv_rv32_init.o
 CC        application/rv32-spiflash/build/platform/miv_rv32_hal/miv_rv32_stubs.o
 CC        application/rv32-spiflash/build/platform/miv_rv32_hal/miv_rv32_syscall.o
 CC        application/rv32-spiflash/build/application/rv32-spiflash/src/main.o
 CC        application/rv32-spiflash/build/application/rv32-spiflash/src/hw_init.o
 CC        application/rv32-spiflash/build/platform/drivers/off_chip/microchip_sst26vf/sst26vf.o
 CC        application/rv32-spiflash/build/platform/drivers/fpga_ip/CoreTimer/core_timer.o
 CC        application/rv32-spiflash/build/platform/drivers/fpga_ip/CoreUARTapb/core_uart_apb.o
 CC        application/rv32-spiflash/build/platform/drivers/fpga_ip/CoreGPIO/core_gpio.o
 CC        application/rv32-spiflash/build/platform/drivers/fpga_ip/CoreSPI/core_spi.o
 CC        application/rv32-spiflash/build/middleware/spi_flash/spi_flash.o
 CC        application/rv32-spiflash/build/middleware/delay/timer_delay.o
 CC        application/rv32-spiflash/build/middleware/stdio/uart_stdio.o
 AS        application/rv32-spiflash/build/platform/miv_rv32_hal/miv_rv32_entry.o
 AS        application/rv32-spiflash/build/platform/hal/hw_reg_access.o
 LD        application/rv32-spiflash/build/rv32-spiflash.elf
 OBJCOPY   application/rv32-spiflash/build/rv32-spiflash.bin
 OBJCOPY   application/rv32-spiflash/build/rv32-spiflash.hex
 NM        application/rv32-spiflash/build/rv32-spiflash.sym
 OBJDUMP   application/rv32-spiflash/build/rv32-spiflash.lst
   text	   data	    bss	    dec	    hex	filename
  17056	    112	 132848	 150016	  24a00	application/rv32-spiflash/build/rv32-spiflash.elf
GNU gdb (xPack GNU RISC-V Embedded GCC (Microsemi SoftConsole build), 64-bit) 9.1


```

## UART Terminal

The Terminal will display teh below options

```
Welcome to minicom 2.7.1                                                  
                                                                          
OPTIONS: I18n                                                                
Compiled on Oct 15 2019, 06:43:27.                                           
Port /dev/ttyUSB0, 23:16:36                                                  
                                                                             
Press CTRL-A Z for help on special keys

<< RV32 SPI Flash Demo >>

Available CMDs:
 h: Help
 i: Display SPI Flash Device Info
 d: Display SPI Flash Content at spi_addr 
 1: Increment the spi_addr by 4K
 2: Decrementthe spi_addr by 4K
 w: Write the initialized buffer content to SPI Flash @spi_addr
 e: erase multiple sector of SPI flash starting at spi_addr  
 x: initialize the buffers for read/write operation

RV32>
 ```

 command `i` output

 ```
 RV32>i 
Idcode : 0xBF , Device ID  : 0x26


 ```

 command `d` output. The SPI flash already has some contents

 ```
 RV32>d
 Flash address:0x00000000
              00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F   ASCII Value 
  ------------------------------------------------------------------------------- 
  0x00000000| 41 41 35 35 00 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A | A A 5 5  j j j j j j j j j j j 
  0x00000010| 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A | j j j j j j j j j j j j j j j j 
  0x00000020| 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A | j j j j j j j j j j j j j j j j 
  0x00000030| 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A | j j j j j j j j j j j j j j j j 
  0x00000040| 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A | j j j j j j j j j j j j j j j j 
  0x00000050| 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A | j j j j j j j j j j j j j j j j 
  0x00000060| 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A | j j j j j j j j j j j j j j j j 
  0x00000070| 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A | j j j j j j j j j j j j j j j j 
  0x00000080| 2A 2A 2A 2A 44 44 52 20 6D 65 6D 6F 72 79 20 63 | * * * * D D R   m e m o r y   c 
  0x00000090| 6F 6E 74 65 6E 74 20 66 6F 72 20 54 65 73 74 69 | o n t e n t   f o r   T e s t i 
  0x000000A0| 6E 67 2A 2A 2A 2A 00 00 00 00 00 00 00 00 00 00 | n g * * * *           
  0x000000B0| 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |                 
  0x000000C0| 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |                 
  0x000000D0| 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |                 
  0x000000E0| 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |                 
  0x000000F0| 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |                 
 press any key to continue or 'x' to exit                       


 ```

 use the commands `x` to erase the sector,  commad `w` to write some predefined buffer data to spi flash etc.





29th Aptil 2026