#---------------------------------------------------
# -- Source Folder Setup
#---------------------------------------------------
APP_HOME         ?= application/$(TARGET)
BINDIR           := $(APP_HOME)/build


#RV32_HOME    ?= .




# Conditional Logic for the default linker file selection
ifeq ($(BOARD), m2s-creative-brd)
    # use esram.ld for m2s-creative board 
    LDFILE      = boards/$(BOARD)/platform_config/linker/miv-rv32-esram.ld
    $(info [BUILD]  Using esram ld fiel for m2s creative board)
else
    # Default/Release-specific flags
    LDFILE      = boards/$(BOARD)/platform_config/linker/miv-rv32-ram.ld
    $(info [BUILD] Default linker fiel used )
endif


#-----------------------------------------------------
# Use the below Option to use a custom linker file
# for running freertos, make sure the linker fiel has the __freertos_irq_stack_top = .;  defined
#  at the end of stack
#-----------------------------------------------------
LDFILE      ?= boards/$(BOARD)/platform_config/linker/miv-rv32-ram-freertos.ld



#  this value should match the ROM origin value form the linker , this is used to generate the hex file which can be used for initilising the LSRAM/envm
#  

RAM_ORIGIN ?= 0x80000000

OBJ_FLAGS += --change-section-lma *-$(RAM_ORIGIN)



#-----------------------------------------------------
# Select the CONFIG Option to use device drivers 
#-----------------------------------------------------
CONFIG_USE_CORE_GPIO     = Y
CONFIG_USE_CORE_UART     = Y
CONFIG_USE_CORE_TIMER    = Y
CONFIG_USE_CORE_SPI      = Y


#-----------------------------------------------------
# Middleware function to be used 
#-----------------------------------------------------
# need the below to enable printf funtions via coreuart
CONFIG_STDIO_THRU_CORE_UART_APB = Y
CONFIG_USE_TIMER_DELAY          = N
CONFIG_USE_CORE_UART_PRINT      = N
CONFIG_USE_SPI_FLASH            = N
CONFIG_USE_YMODEM               = N
CONFIG_USE_SPI_FLASH_FILE_SYS   = N
#CONFIG_USE_CORE_UART_PRINT     = Y
#CONFIG_USE_MSS_UART_PRINT      = Y
#CONFIG_USE_STDIO_MMUART        = Y


#------------------------------------------------------
# FreeRTOS and LwIP CONFIGs
#------------------------------------------------------
CONFIG_USE_FREERTOS  		    = Y
CONFIG_USE_LWIP    			    = N
#------------------------------------------------------






#------------------------------------------
#-- Use the belwo Symbol to change your SYS_CLK Value if needed
#-- default value is specifie in board/{board/fpga_design_config/fpga_design_config.h
#--------------------------------------------
#USER_FLAGS ?= -D SYS_CLK_FREQ=50000000
#----------------------------------------------------------------------



#-----------------------------------------------------
#  By default the build will be for -O0 and -g3,
# use the below switch option to change the optimization and debug levels
#-----------------------------------------------------
#OPT_FLAG   = -Os
#DEBUG_FLAG = -g
#------------------------------------------------------------

              
#------------------------------------------------------------
# Application Source Files
#------------------------------------------------------------
       

C_SRCS += $(APP_HOME)/main.c \
          $(APP_HOME)/rtos-tasks/vTaskCreate.c \
          $(APP_HOME)/rtos-tasks/vTaskDelay.c \
          $(APP_HOME)/rtos-tasks/vTaskDelayUntil.c \
          $(APP_HOME)/rtos-tasks/vTaskSuspend.c \
          $(APP_HOME)/rtos-tasks/vTaskYield.c \
          $(APP_HOME)/rtos-tasks/blinky_with_queue.c
          

# uart_function for stdio
C_SRCS +=  middleware/stdio/uart_stdio.c	
#C_SRCS +=  middleware/stdio/neorv32_stdio.c	

#---------------------------------------------------------
#- Include folders 
#----------------------------------------------------------

APP_INC  +=  -I $(APP_HOME)

APP_INC += -I . \
           -I application \
		   -I middleware \
		   -I platform


#-include platform/config/build.mk	

