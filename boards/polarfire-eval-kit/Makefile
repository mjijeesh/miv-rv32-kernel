


$(info BOARD      = MPF-EVAL-BRD)


BOARD_DIR= boards/polarfire-eval-kit

# set the device partnumer for openocd
M2S_DEVICE = M2S025

BOARD_INC      += -I $(BOARD_DIR)
BOARD_INC      += -I $(BOARD_DIR)/drivers_config/sys_config
BOARD_INC      += -I $(BOARD_DIR)/fpga_design_config

#INCS +=	-I $(BOARD_DIR)/fpga_design_config
#INCS   += -I $(BOARD_DIR)

#CORE_SRC   += $(BOARD_DIR)/drivers_config/sys_config/sys_config.c

ifeq ($(CONFIG_STDIO_THRU_CORE_UART_APB), Y)
  $(info STDIO  = MSCC_STDIO_THRU_CORE_UART_APB)
   USER_FLAGS += -D MSCC_STDIO_THRU_CORE_UART_APB
endif  



################################################################################################
#
# Extra hardware dependency rules for SPI FLASH
#

ifdef CONFIG_USE_MSS_SPI_FLASH
$(info SPIFLASH = MICROCHIP_SST26VF Selected)
USER_FLAGS   += -D CONFIG_SPI_FLASH_MICROCHIP_SST26VF
DRIVER_INC   += -I platform/drivers/off_chip/mss_sst26vf
DRIVER_SRC   +=  platform/drivers/off_chip/sst26vf/sst26vf.c

#C_SRCS-$(CONFIG_SERVICE_QSPI) += drivers/off_chip/sst26vf/sst26vf.c

endif

ifeq ($(CONFIG_USE_SPI_FLASH), Y)
$(info SPIFLASH = Micron MT25QL01GBBB Selected)
USER_FLAGS   += -D CONFIG_SPI_FLASH_MICRON_MT25QL01GBBB
DRIVER_INC   += -I platform/drivers/off_chip/mt25ql01gbbb
DRIVER_SRC   +=  platform/drivers/off_chip/mt25ql01gbbb/mt25ql01gbbb.c

#C_SRCS-$(CONFIG_SERVICE_QSPI) += drivers/off_chip/sst26vf/sst26vf.c

endif


################################################################################################
#
# Linker Scripts
#
LDFILE ?= $(BOARD_DIR)/platform_config/linker/miv-rv32-ram.ld

$(info LINKER     = $(LDFILE))

