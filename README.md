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

```
root@rv32:/#                                                                    
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

