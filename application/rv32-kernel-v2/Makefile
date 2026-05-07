#---------------------------------------------------
# -- Source Folder Setup
#---------------------------------------------------
APP_HOME         ?= application/$(TARGET)
BINDIR           := $(APP_HOME)/build
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

CONFIG_STDIO_THRU_CORE_UART_APB  = Y
CONFIG_USE_CORE_UART_PRINT       = Y
CONFIG_USE_SPI_FLASH             = Y
CONFIG_USE_YMODEM                = N

# need the below to enable printf funtions via coreuart
#CONFIG_STDIO_THRU_CORE_UART_APB = Y
#CONFIG_USE_TIMER_DELAY          = N


#CONFIG_USE_YMODEM               = N
#CONFIG_USE_SPI_FLASH_FILE_SYS   = Y
#CONFIG_USE_CORE_UART_PRINT     = Y
#CONFIG_USE_MSS_UART_PRINT      = Y
#CONFIG_USE_STDIO_MMUART        = Y

#-----------------------------------------------------
# Use the below Option to use a custom linker file
#-----------------------------------------------------
LDFILE      = boards/$(BOARD)/platform_config/linker/miv-rv32-esram.ld

#-----------------------------------------------------
#  By default the build will be for -O0 and -g3,
# use the below switch option to change the optimization and debug levels
#-----------------------------------------------------
#OPT_FLAG   = -Os
#DEBUG_FLAG = -g


#------------------------------------------------------------
# Application Source Files
#------------------------------------------------------------

APP_SRC += $(APP_HOME)/src/main.c 
APP_SRC += middleware/ymodem/ymodem.c 


#---------------------------------------------------------
#- Include folders 
#----------------------------------------------------------

APP_INC  +=  -I $(APP_HOME)

APP_INC += -I . \
           -I application \
		   -I middleware \
		   -I platform
		   
