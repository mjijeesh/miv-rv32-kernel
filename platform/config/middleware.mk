# This file provides the  sources and included path for the drivers used i nthe project
# add or remove the driver sectiona applicable for your need

MIDDLEWARE_HOME    := middleware

BSP_HOME    := $(CM3_HOME)/bsp


#--------------------
# User Flags generation for differnt CONFIG Options
ifeq ($(CONFIG_USE_SPI_FLASH_FILE_SYS), Y)
  USER_FLAGS  += -D USE_SPI_FLASH_FILE_SYS
endif

ifeq ($(CONFIG_USE_SPI_FLASH), Y)
  USER_FLAGS  += -D CONFIG_USE_SPI_FLASH
endif

#------------------------------------------
# FreeRTOS  needs the below ymbols to be defined 
#------------------------------------------------------------
ifeq ($(CONFIG_USE_FREERTOS), Y)
USER_FLAGS +=-D portasmHANDLE_INTERRUPT=handle_trap
USER_FLAGS +=-D TICK_COUNT_PRESCALER=100
-include platform/config/freertos.mk
endif

ifeq ($(CONFIG_USE_LWIP), Y)
-include $(RV32_HOME)/common/lwip.mk
endif



# Check if TARGET_BOARD  has spi flash mmeory is MICRON_1G_SPI_FLASH
ifeq ($(CONFIG_USE_SPI_FLASH), MICRON_1G_SPI_FLASH)
    $(info  Micron 1GB SPI Flash Used)     
    C_SRCS      += $(MIDDLEWARE_HOME)/flash/mt25ql01gbbb/micron1gflash.c
    INCS        += -I $(MIDDLEWARE_HOME)/flash
    INCS        += -I $(MIDDLEWARE_HOME)/flash/mt25ql01gbbb 

endif


# Check if TARGET_BOARD  has spi flash mmeory is MICRON_1G_SPI_FLASH
ifeq ($(CONFIG_USE_SPI_FLASH), Y)
    $(info  SPI FLASH Memory Used)     
    C_SRCS      += $(MIDDLEWARE_HOME)/spi_flash/spi_flash.c
    INCS        += -I $(MIDDLEWARE_HOME)/spi_flash   
endif


ifdef CONFIG_USE_MSS_SPI_FLASH
    $(info  Microchip SST26 Flash Used)     
    C_SRCS      += $(MIDDLEWARE_HOME)/spi_flash/spi_flash.c
    INCS        += -I $(MIDDLEWARE_HOME)/spi_flash    
    USER_FLAGS  += -D CONFIG_USE_MSS_SPI
    

endif



#other  usefull functions


ifeq ($(CONFIG_USE_TIMER_DELAY), Y)
$(info TIMER_DELAY  = Y   Selected)
C_SRCS      += $(MIDDLEWARE_HOME)/delay/timer_delay.c
INCS        += -I $(MIDDLEWARE_HOME)/delay
USER_FLAGS  += -D USE_TIMER_DELAY
#C_SRCS-$(CONFIG_SERVICE_QSPI) += drivers/off_chip/sst26vf/sst26vf.c
else
 ifeq ($(CONFIG_USE_SYSTICK_DELAY), Y)
   $(info DELAY  = SYSTICK DELAY USED)
   C_SRCS      += $(MIDDLEWARE_HOME)/delay/systick_delay.c
   INCS        += -I $(MIDDLEWARE_HOME)/delay
   USER_FLAGS  += -D USE_SYSTICK_DELAY
 endif
 
endif


ifeq ($(CONFIG_USE_CORE_UART_PRINT), Y)
#$(info PRINT  = UART Print enabled)
C_SRCS      += $(MIDDLEWARE_HOME)/stdio/uart_stdio.c
INCS        += -I $(MIDDLEWARE_HOME)/stdio
USER_FLAGS  += -D CORE_UART_PRINT
#C_SRCS-$(CONFIG_SERVICE_QSPI) += drivers/off_chip/sst26vf/sst26vf.c
endif




INCS        += -I $(MIDDLEWARE_HOME)



#ifeq ($(CONFIG_USE_YMODEM), Y)
#$(info  Using Ymodem Libraries for UART )
#C_SRCS      += $(MIDDLEWARE_HOME)/ymodem/ymodem.c
#C_SRCS      += $(MIDDLEWARE_HOME)/file_sys/file_sys.c
#INCS        += -I $(MIDDLEWARE_HOME)/ymodem
#INCS        += -I $(MIDDLEWARE_HOME)/file_sys
#endif


ifeq ($(CONFIG_USE_YMODEM), Y)
$(info YMODEM  = Y   Selected)

  ifeq ($(CONFIG_USE_SYSTICK_DELAY), N)
    $(error CONFIG_USE_SYSTICKR_DELAY not defined) 
  endif
  ifdef CONFIG_USE_STDIO_MMUART
    USER_FLAGS  += -D CONFIG_USE_MSS_UART_YMODEM
    $(info  YMODEM Using MMUART )
  else
    USER_FLAGS  += -D CONFIG_USE_CORE_UART_YMODEM
    $(info  YMODEM Using CORE_UART )
  endif
    
C_SRCS      += $(MIDDLEWARE_HOME)/ymodem/ymodem.c
C_SRCS      += $(MIDDLEWARE_HOME)/file_sys/file_sys.c
INCS        += -I $(MIDDLEWARE_HOME)/ymodem
INCS        += -I $(MIDDLEWARE_HOME)/file_sys
endif





#sdcard library for SPI 
ifeq ($(CONFIG_USE_SPI_SDCARD), Y)
 $(info  Using SPI SDCARD Libraries)
C_SRCS      += $(MIDDLEWARE_HOME)/sdcard/sdcard.c
C_SRCS      += $(MIDDLEWARE_HOME)/sdcard/sdprint.c
INCS        += -I $(MIDDLEWARE_HOME)/sdcard
endif

