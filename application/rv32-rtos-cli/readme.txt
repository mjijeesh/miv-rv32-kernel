This workspace is used for Free RTOS Demo on the MIV-RV32 design on MPF300-EVAL-KIT

This is targetd on a polarfire-eval-kit with RV32 processor running.
The design also uses the MIV IPS for timer plic etc.
The tmc is implmneted with 32KB size

Modified the project to use the Makefile for building

9 May 2023

freertos modifications made :

in the linker file, add the  __freertos_irq_stack_top = .; below in the stack section

.stack : ALIGN(0x10)
  {
    __stack_bottom = .;
    . += STACK_SIZE;
    __stack_top = .;
     _sp = .;
    __freertos_irq_stack_top = .;
  } > ram
  
  
  User variables / symbols used  for the freertos port  to work with.
  make sure that these are passed for both c and assembly file building
  modified the common.mk to add  in assembly section
  
  -D SYS_CLK_FREQ=83000000 \
  -D MSCC_STDIO_THRU_CORE_UART_APB \
  -D portasmHANDLE_INTERRUPT=handle_trap
  
  
  add the following to enable the CLI functions
  
   -D FREERTOS_PLUS_CLI
 
  add the following to enable the Full DEMO 
  
   -D FREERTOS_DEMO_FULL
   
   
 This demo includes the CLI function of the FreeRTOS.
 Only two commands are enabled,
 
 help -- list the list of commands
 task-stats - print current runnign task status
 echo-parameters
 echo-three-parametrs
 
 
application/freertos_basic:

 This is a simple blinky demo where two tasks has been used one of led blinking and another for uart
 4 "knocks"by the uart task followed by a "blink"by teh LED Task
 
 use the  following  options
 
 USER_FLAGS ?= -D SYS_CLK_FREQ=83000000 \
              -D portasmHANDLE_INTERRUPT=handle_trap
 
 application/freertos_cli:
 
  This demo implments the CLI functionalities of the FreeRTOS
  
  Make sure that the  -D FREERTOS_PLUS_CLI switch is enabled and the CLI releated source files are implmented and used.
  
  USER_FLAGS ?= -D SYS_CLK_FREQ=83000000 \
              -D MSCC_STDIO_THRU_CORE_UART_APB \
              -D portasmHANDLE_INTERRUPT=handle_trap \
              -D FREERTOS_PLUS_CLI \
              -D FREERTOS_DEMO_FULL
              
  
  
  Uses Freertos202112 from github
  ----------------------------------------------
  There are two folders in the rtos folder, v10 is from the amazon source with all the additional files needed for CLI and Full demo
  the other oen is from microchip with minimal files
  
  
  used  the lwip from the tcpip/lwip folder this is working with mpf300-eval-kit.
  
  
   17th November 2023
 
 
 
  