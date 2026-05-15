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

# need the below to enable printf funtions via coreuart
#CONFIG_STDIO_THRU_CORE_UART_APB = Y
#CONFIG_USE_TIMER_DELAY          = N

#CONFIG_USE_SPI_FLASH            = Y
#CONFIG_USE_YMODEM               = N
#CONFIG_USE_SPI_FLASH_FILE_SYS   = Y
#CONFIG_USE_CORE_UART_PRINT     = Y
#CONFIG_USE_MSS_UART_PRINT      = Y
#CONFIG_USE_STDIO_MMUART        = Y

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
#-----------------------------------------------------
#LDFILE      = boards/$(BOARD_DIR)/platform_config/linker/miv-rv32-tcm.ld

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


#---------------------------------------------------------
#- Include folders 
#----------------------------------------------------------

APP_INC  +=  -I $(APP_HOME)

APP_INC += -I . \
           -I application \
		   -I middleware \
		   -I platform
		   
