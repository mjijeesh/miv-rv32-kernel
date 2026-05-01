## CKernelRISCV v1.1
---------------------------


v1 of kernel. Added support for spi flash.

* flashinfo  command added
* 



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

## UART Terminal

The Terminal will display teh below options

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