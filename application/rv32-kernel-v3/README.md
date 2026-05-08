## KernelRISCV v3
---------------------------


TODO :  

1. keep the file system persistent by keeping a copy i nthe spi flash . laod this when initializing at power up as well.
2. copy the file from ddr memory to spi flash location

Added the download command.

use the command `download` to download a fiel to the ddr memory via ymodem.
by default the file will be kept in the ddr/lsram mmeory location at `0x80000000` and the file info will be updated in the RAMfile.
.


```
root@rv32:/# help                                                                                                                               
                                                                                                                                                
Commands: ls, cd, pwd, mkdir, touch, cat, echo, rm, info                                                                                        
          pinmode, write, read, gpio, pwm, sh                                                                                                   
          uptime, uname, dmesg, df, free, whoami, clear, reboot ,download                                                                              
GPIO: gpio [pin] on/off/toggle  |  gpio vixa [count]                                                                                            
SH:   sh [file]  -- run script (use ; as line separator)                                                                                        

root@rv32:/# download                                                                                                                           
                                                                                                                                                
 Select the File to upload via ymodem                                                                                                           
C4857 bytes) registered in FS.                                                                                                                  
OK.                                                                                                                                             
                                                                                                                                                
root@rv32:/# ls                                                                                                                                 
home/  dev/    rv32-kernel-v3.hex                                                                                                               
                                                                                                                                                
root@rv32:/# info rv32-kernel-v3.hex                                                                                                            
Name: rv32-kernel-v3.hex                                                                                                                        
Type: File                                                                                                                                      
File address: 0x80000000                                                                                                                        
                                                                                      
root@rv32:/# uptime                                                                                                                             
up 0h 2m 15s                                                                                                                                    
                                                                                                                                                
root@rv32:/# df                                                                                                                                 
Free RAM: 4528 bytes                                                                                                                            
                                                                                                                                                
root@rv32:/# free                                                                                                                               
Free RAM: 4528 bytes                                                                                                                            
                                                                                                                                                
root@rv32:/#                  


```

## KernelRISCV v2
---------------------------

V2 of the kernel :


###  New Feature:
  Added the command ymodem 
  Download a file using ymodem  protocol. The file will be downlaoded into the  LSRAM/DDR memory ara at 0x80000000


### Hardware

  This uses a new hardware design. The RV32 core has been modified to use only a single AHB interface with memory map as beow 
  ```
  0x20000000 - 0x8fffffff

  ```
  An AHBLite interface s used to connect the Slot 7 to MIV_ESS and Slot8 to the DDR Interface and Slot 2 to FIC_0 of CM3 .
  The 0x20000000 give access to the on chip 64KB of esram. The program is going to run from this memory. reset address of the RV32 is kept at 0x80000000 itself. can be changed later.

  When runnign the program from DDR memory, ymodem never works for some strange reason.

  However the fiel can be downlaoded into the ddr memory.

  This also needs a new linker file.
  `miv-rv32-esram.ld`

  ```

    MEMORY
    {
        ram (rwx) : ORIGIN = 0x20000000, LENGTH = 64k /* 512k previously */
    }

    RAM_START_ADDRESS   = 0x20000000;       /* Must be the same value MEMORY region ram ORIGIN above. */        
    RAM_SIZE            = 64k;              /* Must be the same value MEMORY region ram LENGTH above. */
    STACK_SIZE          = 4k;               /* needs to be calculated for your application */ /* 2k previously */
    HEAP_SIZE           = 1k;               /* needs to be calculated for your application */ /* 4 previously */


  ```

### Running the `ymodem' command

 from the terminam menu  use the command `ymodem'  .

 This will start teh ymodem transfer.
 Use the terminal application's ymodem tarnsfer option.

 For eg: in `minicom`  Ctrl-A + Z -> S -> ymodem -> select file



```
root@rv32:/# ymodem             
                                                                                                                                            
------------------------ Starting YModem file transfer to ram/ddr Memory----------
Please select file and initiate transfer on host computer.                                                                                      
CCC
File Size : 127999  File Name :  rv32-kernel-v2.bin
File Transfer Completed.


```

end of update 
7th April 2026
-----------------------------------------------------------------------------------------------------------------------------------------

v1 of kernel. Added support for spi flash.

below flash commands implmented 
* flash [info|read|write|erase] <args>



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
CONFIG_USE_SPI_FLASH             = Y


```

`ms_ticks` is generated at every SYTICK timeout interval. 
This is used for the delay() function and time keeping.


`MRV_systick_config(SYS_CLK_FREQ/1000);`  start the Sytick timer with the  rescaler.


`CONFIG_USE_CORE_UART_PRINT` enables the additional formatted printing functions like `hex_view_print()`
This function prints a buffer . The implmentation is done in the  `middleware/stdio/uart_stdio.c` file.
This provides functions like
  - `PRINT_TEXT()`
  - `PRINT_XNUM(0)`
  - `PRINT_DNUM()`
  - `hex_view_buffer()`  : print the array in hex format


  
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
 $ make run_all debug  TARGET=rv32-kernel-v0 BOARD=m2s-creative-brd

 ```

 ```


 S---------------- BOARD CONFIGURATION ----------------

TARGET BOARD    = m2s-creative-brd
DEVICE          = M2S025-VF256
LINKER          = boards/m2s-creative-brd/platform_config/linker/miv-rv32-ram.ld
APP_NAME        = rv32-kernel-v0
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

 OBJDUMP   application/rv32-spiflash/build/rv32-spiflash.lst
   text	   data	    bss	    dec	    hex	filename
  17056	    112	 132848	 150016	  24a00	application/rv32-kernel-v0build/rv32-kernel-v0.elf
GNU gdb (xPack GNU RISC-V Embedded GCC (Microsemi SoftConsole build), 64-bit) 9.1


```

## SPI Commands

The Terminal will display teh below options

```

root@rv32:/# 
Initialising Flash mmeory 
Configuring the SPI Flash....
Found SPI Flash ....
Device ID    :0x00000026
ManfactureID :0x000000BF
SPI Flash Configuration -------OK
Initialising File System 
root@rv32:/# uname
Kernel      : KernelRISCV v1.0
Architecture: Mi-V RV32IM
Hardware    : Microchip Creative Board
RAM         : 131536 bytes free
Build Date  : May  1 2026 20:16:12

root@rv32:/# flash info
                        
Idcode : 0xBF , Device ID  : 0

oot@rv32:/# flash
                  Usage: flash [info|read|write|erase] <args>

root@rv32:/# 

root@rv32:/# flash erase 0x500
                              Erasing sector at 0x00000500...

 Number of sectors to be erased :  1
 Erasing Sector @ 0x00000500
 Erasing Completed 
 :Done.

root@rv32:/# 


root@rv32:/# flash write 0x100 abcdef

 Writing File Completed
Wrote 6 bytes to 0x00000100

root@rv32:/# 

root@rv32:/# flash read 0x100

              00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F   ASCII Value 
  ------------------------------------------------------------------------------- 
  0x00000100| 61 62 63 64 65 66 FF FF FF FF FF FF FF FF FF FF | a b c d e f � � � � � � � � � � 
  0x00000110| FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF | � � � � � � � � � � � � � � � � 
  0x00000120| FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF | � � � � � � � � � � � � � � � � 
  0x00000130| FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF | � � � � � � � � � � � � � � � � 
  0x00000140| FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF | � � � � � � � � � � � � � � � � 
  0x00000150| FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF | � � � � � � � � � � � � � � � � 
  0x00000160| FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF | � � � � � � � � � � � � � � � � 
  0x00000170| FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF | � � � � � � � � � � � � � � � � 
  0x00000180| FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF | � � � � � � � � � � � � � � � � 
  0x00000190| FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF | � � � � � � � � � � � � � � � � 
  0x000001A0| FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF | � � � � � � � � � � � � � � � � 
  0x000001B0| FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF | � � � � � � � � � � � � � � � � 
  0x000001C0| FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF | � � � � � � � � � � � � � � � � 
  0x000001D0| FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF | � � � � � � � � � � � � � � � � 
  0x000001E0| FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF | � � � � � � � � � � � � � � � � 
  0x000001F0| FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF | � � � � � � � � � � � � � � � � 
 press any key to continue or 'x' to exit






 ```


 ### Basic Commands 

```
Initialising RV32 Kernel                                                        
root@rv32:/# uname                                                              
Kernel      : KernelRISCV v1.0                                                  
Architecture: Mi-V RV32IM                                                       
Hardware    : Microchip Creative Board                                          
RAM         : 131584 bytes free                                                 
Build Date  : May  1 2026 17:08:56                                              
                                                                                
root@rv32:/# uptime                                                             
up 0h 0m 5s                                                                     
                                                                                
root@rv32:/# 


root@rv32:/# help                                                               
                                                                                
Commands: ls, cd, pwd, mkdir, touch, cat, echo, rm, info                        
          pinmode, write, read, gpio, pwm, sh                                   
          uptime, uname, dmesg, df, free, whoami, clear, reboot                 
GPIO: gpio [pin] on/off/toggle  |  gpio vixa [count]                            
SH:   sh [file]  -- run script (use ; as line separator)                        
root@rv32:/# 


root@rv32:/# gpio                                                               
                                                                                
Usage: gpio [pin] [on/off] OR gpio vixa [count]                                 
root@rv32:/# gpio 1 on                                                          
GPIO 1 ON                                                                       
root@rv32:/# gpio 0 on                                                          
GPIO 0 ON                                                                       
root@rv32:/# gpio vixa 20                                                       
LED DISCO MODE!                                                                 
Disco finished!                                                                 
root@rv32:/# 


root@rv32:/# pwd                                                                
/                                                                               
                                                                                
root@rv32:/# ls                                                                 
home/  dev/                                                                     
                                                                                
root@rv32:/# mkdir test                                                         
OK.                                                                             
                                                                                
root@rv32:/# ls                                                                 
home/  dev/  test/                                                              
                                                                                
root@rv32:/# 

root@rv32:/# reboot                                                             
Rebooting (Software)...                                                         
                                                                                
root@rv32:/# panic                                                              
KERNEL PANIC: Manual Trigger 

 ```


1st may 2026