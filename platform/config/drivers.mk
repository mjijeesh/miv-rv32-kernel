# This file provides the  sources and included path for the drivers used i nthe project
# add or remove the driver sectiona applicable for your need

DRIVERS_HOME  := platform/drivers

FPGA_DRIVERS  := $(DRIVERS_HOME)/fpga_ip
MSS_DRIVERS   := $(DRIVERS_HOME)/mss_ip



# Initialize status variables as DISABLED by default
CORE_TIMER_STATUS := [DISABLED]
CORE_UART_STATUS  := [DISABLED]
CORE_GPIO_STATUS  := [DISABLED]
CORE_SPI_STATUS   := [DISABLED]



#DRIVERS_HOME  := platform/drivers


ifneq (,$(findstring MSS_TSE,$(USER_FLAGS)))
C_SRCS +=  $(MSS_DRIVERS)/mss_ethernet_mac/mss_ethernet_mac.c	      
INCS   += -I $(MSS_DRIVERS)/mss_ethernet_mac
endif


#---------------------------------------------------
# Select one of the MAC IP for the project
#   USER_FLAGS :=-D USE_CoreTSE 
#   USER_FLAGS :=-D USE_MSSTSE
#------------------------------------------------------
ifneq (,$(findstring MSS_TSE,$(USER_FLAGS)))
C_SRCS +=  $(MSS_DRIVERS)/mss_ethernet_mac/mss_ethernet_mac.c	      
INCS   += -I $(MSS_DRIVERS)/mss_ethernet_mac
endif



ifeq ($(TARGET_BOARD), polarfire-eval-kit)	

   ifneq (,$(findstring CORE_TSE,$(USER_FLAGS)))
   USER_FLAGS += -D PHY_VSC8575 
    C_SRCS += $(FPGA_DRIVERS)/CoreTSE/core_tse.c \
			$(FPGA_DRIVERS)/CoreTSE/crc32.c   			
	INCS   += -I $(FPGA_DRIVERS)/CoreTSE
	C_SRCS += $(ARCH_HOME)/middleware/ZL30364/zl30364_config.c  
    INCS   += -I $(ARCH_HOME)/middleware/ZL30364

	
  endif
endif


ifeq ($(TARGET_BOARD), polarfire-splash-kit)

   ifneq (,$(findstring CORE_TSE,$(USER_FLAGS)))
	USER_FLAGS += -D PHY_VSC8541
	C_SRCS += $(FPGA_DRIVERS)/CoreTSE/core_tse.c \
			$(FPGA_DRIVERS)/CoreTSE/crc32.c   			
	INCS   += -I $(FPGA_DRIVERS)/CoreTSE


  endif
endif


#---------------------------------------------------
# Select one of Ethernet PHY from the below 
#   USER_FLAGS :=-D PHY_VSC8541 
#   USER_FLAGS :=-D PHY_VSC8541
#   USER_FLAGS :=-D PHY_M88E1340
#------------------------------------------------------

ifneq (,$(findstring PHY_VSC8541,$(USER_FLAGS)))
C_SRCS += $(FPGA_DRIVERS)/CoreTSE/vsc8541/vsc8541_phy.c
INCS   += -I $(FPGA_DRIVERS)/CoreTSE/vsc8541
endif

ifneq (,$(findstring PHY_VSC8575,$(USER_FLAGS)))
C_SRCS += $(FPGA_DRIVERS)/CoreTSE/vsc8575/vsc8575_phy.c
INCS   += -I $(FPGA_DRIVERS)/CoreTSE/vsc8575
endif

ifneq (,$(findstring PHY_M88E1340,$(USER_FLAGS)))
C_SRCS += $(FPGA_DRIVERS)/CoreTSE/m88e1340/m88e1340_phy.c
INCS   += -I $(FPGA_DRIVERS)/CoreTSE/m88e1340
endif



# -- ---------------------------------------------
# -- Common Driver Sources 
# -------------------------------------------------      

ifeq ($(CONFIG_USE_CORE_TIMER), Y)
CORE_TIMER_STATUS := [ENABLED]
DRIVER_SRC   += $(FPGA_DRIVERS)/CoreTimer/core_timer.c
DRIVER_INC   += -I $(FPGA_DRIVERS)/CoreTimer
endif

ifeq ($(CONFIG_USE_CORE_UART), Y)
CORE_UART_STATUS := [ENABLED]
DRIVER_SRC   +=	$(FPGA_DRIVERS)/CoreUARTapb/core_uart_apb.c
INCS     +=	-I $(FPGA_DRIVERS)/CoreUARTapb
endif

ifeq ($(CONFIG_USE_MSS_UART), Y)
DRIVER_REPORT += MSS_UART         :[ENABLED]
DRIVER_SRC   +=	$(MSS_DRIVERS)/mss_uart/mss_uart.c
INCS     +=	-I $(MSS_DRIVERS)/mss_uart
endif


ifeq ($(CONFIG_USE_CORE_GPIO), Y)
CORE_GPIO_STATUS := [ENABLED]
DRIVER_SRC   += $(FPGA_DRIVERS)/CoreGPIO/core_gpio.c
DRIVER_INC   += -I $(FPGA_DRIVERS)/CoreGPIO
endif

ifeq ($(CONFIG_USE_MSS_GPIO), Y)
DRIVER_REPORT +=MSS_GPIO  :[ENABLED]
DRIVER_SRC   += $(MSS_DRIVERS)/mss_gpio/mss_gpio.c
DRIVER_INC   += -I $(MSS_DRIVERS)/mss_gpio
endif

ifeq ($(CONFIG_USE_CORE_SPI), Y)
CORE_SPI_STATUS := [ENABLED]
DRIVER_SRC   += $(FPGA_DRIVERS)/CoreSPI/core_spi.c
DRIVER_INC   +=	-I $(FPGA_DRIVERS)/CoreSPI
endif

ifeq ($(CONFIG_USE_MSS_SPI), Y)
DRIVER_REPORT += MSS_SPI    :[ENABLED]
DRIVER_SRC   += $(MSS_DRIVERS)/mss_spi/mss_spi.c
DRIVER_INC   +=	-I $(MSS_DRIVERS)/mss_spi
endif



# The below are needed for IAP/ISP etc
#DRIVER_SRC   += $(MSS_DRIVERS)/mss_sys_services/mss_comblk.c
#DRIVER_SRC   += $(MSS_DRIVERS)/mss_sys_services/mss_sys_services.c
#DRIVER_INC   +=	-I $(MSS_DRIVERS)/mss_sys_services
	  
		   	  
INCS     += -I $(FPGA_DRIVERS)



# Define targets that qualify as "build" operations
BUILD_TARGETS := all elf bin hex sym lst size clean_all

# Only print the summary if we are actually building
ifneq ($(filter $(BUILD_TARGETS),$(MAKECMDGOALS)),)
    $(info ---------------- Driver & Middleware Status ----------------)
    #$(info TARGET BOARD    = $(BOARD))
    #$(info OPTIMIZATION    = $(OPT_FLAG))
    #$(info DEBUG LEVEL     = $(DEBUG_FLAG))
    $(info )
      
    #$(info -- Driver & Middleware Status --)
    $(info CORE_TIMER       = $(CORE_TIMER_STATUS))
    $(info CORE_UART        = $(CORE_UART_STATUS))
    $(info CORE_GPIO        = $(CORE_GPIO_STATUS))
    $(info CORE_SPI         = $(CORE_SPI_STATUS))
    
    $(info -------------------------------------------------------)
    $(info USER_FLAGS      = $(USER_FLAGS))
    $(info -------------------------------------------------------)
endif



         

           
#-----------------------------------------------------------                 			  
		  

            