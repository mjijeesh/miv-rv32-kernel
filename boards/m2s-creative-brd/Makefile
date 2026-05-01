



BOARD_DIR= boards/m2s-creative-brd

# set the device partnumer for openocd
M2S_DEVICE     ?= M2S025-VF256

# STD IO Driver 

STDIO ?=

BOARD_INC      += -I $(BOARD_DIR)
BOARD_INC      += -I $(BOARD_DIR)/drivers_config/sys_config
BOARD_INC      += -I $(BOARD_DIR)/fpga_design_config

#INCS +=	-I $(BOARD_DIR)/fpga_design_config
#INCS   += -I $(BOARD_DIR)

#CORE_SRC   += $(BOARD_DIR)/drivers_config/sys_config/sys_config.c

ifeq ($(CONFIG_STDIO_THRU_CORE_UART_APB), Y)
   STDIO := MSCC_STDIO_THRU_CORE_UART_APB
   USER_FLAGS += -D MSCC_STDIO_THRU_CORE_UART_APB
endif  


################################################################################################
#
# Extra hardware dependency rules for SPI FLASH
###############################################################################

ifeq ($(CONFIG_USE_SPI_FLASH), Y)
$(info SPIFLASH = MICROCHIP_SST26VF Selected)
USER_FLAGS   += -D CONFIG_SPI_FLASH_MICROCHIP_SST26VF
DRIVER_INC   += -I platform/drivers/off_chip/microchip_sst26vf
DRIVER_SRC   +=  platform/drivers/off_chip/microchip_sst26vf/sst26vf.c
endif




################################################################################################
#
# Linker Scripts
#
LDFILE ?= $(BOARD_DIR)/platform_config/linker/miv-rv32-ram.ld

#$(info LINKER = $(BOARD_DIR))
#$(info LINKER = $(LDFILE))
$(info  )
$(info ---------------- BOARD CONFIGURATION ----------------)
$(info  )
$(info TARGET BOARD    = $(BOARD))
$(info DEVICE          = $(M2S_DEVICE))
$(info LINKER          = $(LDFILE))
$(info APP_NAME        = $(TARGET))
$(info STDIO           = $(STDIO))

$(info )


