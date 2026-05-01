**This Project Repo has the FreeRTOS Demo Application **

**- Libero       : v2025.1**
**- Softconsole  : v2022.2**



# Basic MIV_RV32 Examples 

```

- rv32-timer-irq        : Timer interrupt Example  
- rv32-timer-delay      : Delay Example using Timer
- rv32-systick          : Systick Example
- rv32-systick-delay    : Delay Example using systick
- rv32-spiflash         : SPI Flash Interface Example


```
Below are Not Tested in this  commit.

### Items Not Tested in This Commit
```
- rv32-spiflash-ymodem  : Ymodem Example
- rv32-sdcard             sdcard example
```

# Building Demo

Use the make command with apropritate Parameter to build and run the examples.

```shell
$ make BOARD=m2s-creative-brd TARGET= rv32-systick  clean all
```


### Build Commands
```bash
# Build the "rv32-systick" example for the m2s-creative-brd (default)
$ make BOARD=m2s-creative-brd TARGET=rv32-systick clean all
```

This will  build the  "rv32-systick"  example. targettign the  m2s-creative-brd.

by default the BOARD = m2s-creative-brd, so we can skip that argument.

```shell
$ make TARGET= rv32-coretimer-irq clean all  
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











""" RTOS Example apps """
###################################################

rv32-rtos-cli  : This demo ask implements he basic CLI application 
rv32-rtos-demo :  This implments the basic blinky app along with basic rtos structure, liek createTask, DeleteTask, SuspendTak etc.
                    Use the options mentioned in the respective readme for options


####################################################

The Design is tested with the MIV_RV32 v3.0.100 implemented in Creative-BRD.
The DDR memory is initialised and used at 0x80000000 for the program memory.

Linker File modifications:
------------------------------------------------
Make sure that the following symbol is defined in the linekr file  for freertos examples

in the linker file, add the  __freertos_irq_stack_top = .; below in the stack section

.stack : ALIGN(0x10)
  {
    __stack_bottom = .;
    . += STACK_SIZE;
    __stack_top = .;
     _sp = .;
    __freertos_irq_stack_top = .;
  } > ram
  
**SYmbols and Definitions**
-------------------------------------------------
The below SYMBOLS and Definition help the makefiles to add the different files and features for the Demo to run 

CONFIG_USE_FREERTOS  		    = Y 


The above symbol is used to enable the Makefile  to add the  freeRTOS core files needed for the demo.
The SYMBOLS -D portasmHANDLE_INTERRUPT=handle_trap , and -D TICK_COUNT_PRESCALER=100 will be declared by the Makefile when this is declared.
This is doen i the platform/config/freertos.mk file 

USER_FLAGS += -D FREERTOS_DEMO_FULL 
USER_FLAGS += -D FREERTOS_PLUS_CLI

These above SYMBOLS are used in the demo program to enable /disable the full demo/cli demo.to run the CLI demo these needs to be declared.

 
USER_FLAGS += -D SYS_CLK_FREQ=50000000

USER_FLAGS += -D MSCC_STDIO_THRU_CORE_UART_APB
The above symbol is needed to use the new_lib functions needed for the printf()
  
  
 

######################################################################################
CLI Demo
#######################################################################################  
   
 This demo includes the CLI function of the FreeRTOS.
 Only two commands are enabled,
 
 help -- list the list of commands
 task-stats - print current running task status
 echo-parameters
 echo-three-parametrs
 
 
application/freertos_basic:

 This is a simple blinky demo where two tasks has been used one of led blinking and another for uart
 4 "knocks"by the uart task followed by a "blink"by teh LED Task
 
 use the  following  options
 
 CONFIG_USE_FREERTOS  		    = Y

 
 application/freertos_cli:
 
  This demo implments the CLI functionalities of the FreeRTOS
  
  Make sure that the  -D FREERTOS_PLUS_CLI switch is enabled and the CLI related source files are implemented and used.
  
  CONFIG_USE_FREERTOS  		    = Y
  CONFIG_STDIO_THRU_CORE_UART_APB   = Y
  USER_FLAGS +=  -D FREERTOS_PLUS_CLI \
                 -D FREERTOS_DEMO_FULL
              
    
    
   8th February 2025
 
 
 
  