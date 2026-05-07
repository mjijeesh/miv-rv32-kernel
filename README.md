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




##  KernelRISCV  V1.0

**- Libero       : v2025.1**
**- Softconsole  : v2022.2**



This Demo example implments a Kernel for MIV-RV32 .
This is trying to mimic the functionality of the "KernelUNO" which is done for Arduino.

# Building Demo

Use the make command with apropritate Parameter to build and run the examples.

```shell
$ make  BOARD=m2s-creative-brd TARGET= v32-kernel-v0  clean all
```


### Build Commands
```bash
# Build the "rv32-systick" example for the m2s-creative-brd (default)
$ make  TARGET=v32-kernel-v0  clean all
```

This will  build the  "32-kernel-v0"  example. targettign the  m2s-creative-brd.

by default the BOARD = m2s-creative-brd, so we can skip that argument.

```shell
$ make TARGET= 32-kernel-v0 clean all  
```

The above will run the coretimer-irq example


Change the TARGET parameter to run different examples. or use modify inside the Makefile 


# Running openocd Server
```
$ make  openocd 
```

This will launch the opencd server for debug. Run it on a different terminal and keep it running


### Debugging the Application
```
$ make  debug
```

This is will load the elf file 

use "cont" comamnd to run further



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

