



### OpenOCD Debugger Related stuff
# OpenOCD executable
OPENOCD = openocd
# M2S_DEVICE needs to be defiend with a proper value . by defaul defined in the boards/makefile
#M2S_DEVICE ?= M2S025

# OpenOCD target and configuration files
TARGET_CFG = board/microsemi-riscv.cfg

# Optional OpenOCD arguments
OPENOCD_ARGS =   $(TARGET_CFG)

# OpenOCD command to set the device, provided by borads/Makefile
#OPENOCD_DEVICE_CMD =  "set DEVICE $(M2S_DEVICE)"

# Other OpenOCD commands tobe used 

#adapter_khz 1000 ; reset_config srst_only ;
#OPENOCD_CMD = gdb_port 3333 ; telnet_port 4444 ; tcl_port 6666 ; init; reset halt; sleep 100;





OPENOCD_CMD = gdb_port 3333 ; telnet_port 4444 ; tcl_port 6666 ; adapter_khz 1000 ;




# 1. Define targets that qualify as "build" operations
BUILD_TARGETS := openocd

# 2. Only execute info calls if the current goal is in the build list 
# or if no target was specified (defaults to 'all')
ifneq ($(filter $(BUILD_TARGETS),$(MAKECMDGOALS)),)
    $(info ------OPENOCD CONFIGURATION--------)
    $(info OPENOCDCMD      = $(OPENOCD))
    $(info TARGET_CFG      = $(TARGET_CFG))
    $(info OPENOCD_ARGS    = $(OPENOCD_CMD))
endif

$(info  )






## always provide the DEVICE argument before -f file.cfg argument
openocd:
	$(OPENOCD)  -f $(OPENOCD_ARGS)  -c "$(OPENOCD_CMD)"

	
	
openocd_old: $(BUILD_DIR)/$(TARGET).hex
	$(CMD_ECHO) $(OPENOCD) -c \
	"init; \
	reset halt; \
	sleep 100; \
	reset halt"

gdb_old:$(BUILD_DIR)/$(TARGET).elf 
	$(CMD_ECHO) $(GDB) $(BUILD_DIR)/$(TARGET).elf \
	-ex "target remote localhost:3333"; \
	-ex "load"; \
	-ex "monitor halt";