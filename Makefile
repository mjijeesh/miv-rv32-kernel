#---------------------------------------------------
# -- Source Folder Setup
#---------------------------------------------------
#TARGET       ?= rv32-coretimer-irq
#TARGET        ?= uartcli
#TARGET        ?= rv32-kernel-v0
#TARGET        ?= rv32-kernel-v5
TARGET        ?= rv32-rtos-demo

#-----------------------------------------------------
#select one of the board from the below list available 
#-----------------------------------------------------
BOARD     ?= m2s-creative-brd
#BOARD    ?= polarfire-eval-kit
#BOARD    ?= m2s-security-kit

BUILD     ?= DEBUG


#-----------------------------------------------------
#  By default the build will be for -O0 and -g3,
# use the below switch option to change the optimization and debug levels
#-----------------------------------------------------

# Conditional Logic for Compiler Flags
ifeq ($(BUILD), DEBUG)
    # Debug-specific flags
    CFLAGS += -g3 -O0
    $(info [BUILD] Configuring for Debug mode (-g3 -O0))
else
    # Default/Release-specific flags
    CFLAGS += -g -Os
    $(info [BUILD] Configuring for Release mode (-g -Os))
endif

#OPT_FLAG   = -Os
#DEBUG_FLAG = -g

#-------------------------------
# -- Include the Application specifi Makefile from the application folder

include application/${TARGET}/Makefile

include platform/config/build.mk



