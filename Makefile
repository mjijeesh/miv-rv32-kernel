#---------------------------------------------------
# -- Source Folder Setup
#---------------------------------------------------
#TARGET       ?= rv32-coretimer-irq
#TARGET        ?= uartcli
#TARGET        ?= rv32-kernel-v0
TARGET        ?= rv32-kernel-v5

#-----------------------------------------------------
#select one of the board from the below list available 
#-----------------------------------------------------
#BOARD     ?= m2s-creative-brd
BOARD    ?= polarfire-eval-kit
#BOARD    ?= m2s-security-kit


#-----------------------------------------------------
#  By default the build will be for -O0 and -g3,
# use the below switch option to change the optimization and debug levels
#-----------------------------------------------------
#OPT_FLAG   = -Os
#DEBUG_FLAG = -g

#-------------------------------
# -- Include the Application specifi Makefile from the application folder

include application/${TARGET}/Makefile

include platform/config/build.mk



