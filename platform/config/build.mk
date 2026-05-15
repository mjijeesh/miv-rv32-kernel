#
# Makefile for RISC-V
# 
# Example makes use of the Smartfusion2  MSS peripheral Library
#
# Authored by jijeesh@tecnomic.com
## MakFile Type 1:  uses the below command for findign and building object files
# # this create the object files into the build directory instead of the source folder.
# the vpath provides a virtual path of each source file inside the build folder 
#OBJS = $(addprefix $(BUILD_DIR)/,$(notdir $(SRCS:.c=.o)))
#vpath %.c $(sort $(dir $(SRCS)))

#OBJS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SRCS:.S=.o)))
#vpath %.S $(sort $(dir $(ASM_SRCS)))

#APP_SRC ?= $(wildcard ./*.c) $(wildcard ./*.s) $(wildcard ./*.cpp)
#APP_ASM ?= $(wildcard ./*.S)


# enable or disable the verbose message in compile




# add the board files first 
# Select the board files based on the slection, default to m2s-creative-brd if no BOARD specified
ifneq ("$(wildcard boards/${BOARD}/Makefile)","")
  include boards/${BOARD}/Makefile
else  
    $(error Makefile Not found : at ${BOARD}/Makefile.ld)
endif

#include other makefiles for middleware etc

#include platform/config/openocd.mk
#include platform/config/gdb.mk
include platform/config/drivers.mk
include platform/config/middleware.mk



# if lwip is used , include the files

#ifeq ($(CONFIG_USE_LWIP), Y)
#-include $(RV32_HOME)/common/lwip.mk
#endif


ifeq ($(V), 1)
else
.SILENT:
endif


#default build directory and target name if not defined in application makefile
TARGET      ?= firmware
BINDIR      ?= build


#GCC_EXE_PATH  := C:/Microsemi/SoftConsole_v4.0/arm-none-eabi-gcc/bin
#CROSS_COMPILE ?= $(GCC_EXE_PATH)/arm-none-eabi-
# Cross-compiler tools
CROSS_COMPILE ?= riscv64-unknown-elf-
CC      = $(CROSS_COMPILE)gcc
AS      = $(CROSS_COMPILE)gcc -x assembler-with-cpp
LD      = $(CROSS_COMPILE)gcc
GDB     = $(CROSS_COMPILE)gdb
SIZE    = $(CROSS_COMPILE)size
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
NM      = $(CROSS_COMPILE)nm
ECHO    = echo
MAKE    = make
CP      = cp



# User's application include folders (don't forget the '-I' before each entry)
APP_INC ?= -I .
# User's application include folders - for assembly files only (don't forget the '-I' before each entry)
ASM_INC ?= -I .


USER_FLAGS += -D MSCC_NO_RELATIVE_PATHS


CORE_SRC  += platform/hal/hal_irq.c
CORE_SRC  += platform/miv_rv32_hal/miv_rv32_hal.c
CORE_SRC  += platform/miv_rv32_hal/miv_rv32_init.c
CORE_SRC  += platform/miv_rv32_hal/miv_rv32_stubs.c
CORE_SRC  += platform/miv_rv32_hal/miv_rv32_syscall.c

       		        		

ASM_SRCS  += platform/miv_rv32_hal/miv_rv32_entry.S
ASM_SRCS  += platform/hal/hw_reg_access.S

CORE_INC += -I platform
CORE_INC += -I platform/hal
    	  
 
# Define all sources

SRCS     += $(CORE_SRC)
SRCS     += $(APP_SRC)
SRCS     += $(DRIVER_SRC)
SRCS     += $(C_SRCS)


## below is to avoid error if the user application doesn't include any assembly files
ifdef APP_ASM
ASM_SRCS +=$(APP_ASM)
endif

INCDIRS  +=$(INCS)
INCDIRS  +=$(CORE_INC)
INCDIRS  +=$(APP_INC)
INCDIRS  +=$(DRIVER_INC)
INCDIRS  +=$(BOARD_INC)

# Define all object files

# this create teh object files into the build directory instead of the source folder.
# the vpath provides a virtual path of each source file inside the build folder 

#OBJS = $(addprefix $(OBJ_DIR)/,$(notdir $(SRCS:.c=.o)))
#vpath %.c $(sort $(dir $(SRCS)))

#OBJS += $(addprefix $(OBJ_DIR)/,$(notdir $(ASM_SRCS:.S=.o)))
#vpath %.S $(sort $(dir $(ASM_SRCS)))


OBJS := $(patsubst %.c,$(BINDIR)/%.o,$(SRCS))
vpath %.c $(sort $(dir $(SRCS)))

OBJS += $(patsubst %.S,$(BINDIR)/%.o,$(ASM_SRCS))
vpath %.S $(sort $(dir $(ASM_SRCS)))



# if no linker file specified in the user Makefile, use the default linker file
#LDFILE ?= CMSIS/startup_gcc/debug-m2s-esram.ld


# Target output file names
# Output files
APP_ELF = $(BINDIR)/$(TARGET).elf
APP_BIN = $(BINDIR)/$(TARGET).bin
APP_HEX = $(BINDIR)/$(TARGET).hex
APP_LST = $(BINDIR)/$(TARGET).lst
APP_MAP = $(BINDIR)/$(TARGET).map
APP_SYM = $(BINDIR)/$(TARGET).sym


OPT_FLAG   ?= -O0
DEBUG_FLAG ?= -g3

#-mcpu=cortex-m3 -mthumb -O2 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -DNDEBUG


#-------------------- Compile and Linking options -----------------------------#
# C Source compile options
CFLAGS	  += -march=rv32imc -mabi=ilp32 $(DEBUG_FLAG) $(OPT_FLAG) -std=gnu11
CFLAGS    += --specs=nano.specs
CFLAGS    += -mcmodel=medany 
CFLAGS    += -msmall-data-limit=8  
CFLAGS    += -mstrict-align -mno-save-restore 
CFLAGS	  += -fmessage-length=0 -fsigned-char -fdata-sections -ffunction-sections 

# Linking options 
LDFILE    ?= boards/$(TARGET_BOARD)/platform_config/linker/miv-rv32-ram.ld

LDFLAGS   += -march=rv32imc -mabi=ilp32 $(DEBUG_FLAG) $(OPT_FLAG)
LDFLAGS   += -mcmodel=medany
LDFLAGS   += --specs=nosys.specs
LDFLAGS   += -msmall-data-limit=8
LDFLAGS   += -mstrict-align -mno-save-restore 
LDFLAGS   += -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections 
LDFLAGS   += -T$(LDFILE) 
LDFLAGS	  += -Xlinker --gc-sections -nostartfiles --specs=nano.specs 


# assembly files  compile options


ASM_FLAGS += -march=rv32imc -mabi=ilp32 $(OPT_FLAG)  $(DEBUG_FLAG) -x assembler-with-cpp
ASM_FLAGS += -mcmodel=medany 
ASM_FLAGS += -msmall-data-limit=8
ASM_FLAGS += -mstrict-align -mno-save-restore 
ASM_FLAGS += -fmessage-length=0 -fsigned-char -fdata-sections -ffunction-sections 

#object gen flags for hex file

OBJ_FLAGS ?= 
#OBJ_FLAGS += --change-section-lma *-0x80000000




LIBS ?=


# below are the build list for easy access. 
# COMPILE_DIR has to be created before evry other call
#asm:     $(BINDIR) $(APP_ASM)
elf:     $(BINDIR) $(APP_ELF)
hex:     $(BINDIR) $(APP_HEX)
bin:     $(BINDIR) $(APP_BIN)
lst:     $(BINDIR) $(APP_LST)
sym:     $(BINDIR) $(APP_SYM)

all: elf bin hex sym  lst size

clean_all : clean all







# 1. Only print the  source files and included directory info when -D DEBUG is used

ifneq (,$(findstring DEBUG,$(USER_FLAGS)))
$(info OPTIMIZATION  = $(OPT_FLAG))
$(info DEBUG LEVEL   = $(DEBUG_FLAG))
$(info DIRS          = $(INCDIRS))
$(info SRCS          = $(SRCS))
$(info USER_FLAGS    = $(USER_FLAGS))
$(info CFLAGS        = $(CFLAGS))
$(info LDFLAGS       = $(LDFLAGS))
$(info ASM_FLAGS     = $(ASM_FLAGS))

endif


# Add the Openocd  file 
include platform/config/openocd.mk
include platform/config/gdb.mk



#$ add (OBJS)  below to get individual module size
sizeb:  $(APP_ELF)
	$(SIZE) --format=berkeley $^
size:  $(APP_ELF)
	$(SIZE) --format=sysv --totals --radix=16 $^
	$(SIZE) --format=berkeley $^

$(APP_SYM): $(APP_ELF)
	$(ECHO) " NM        $@"
	@$(NM) $< > $@

$(APP_LST):$(APP_ELF)
	$(ECHO) " OBJDUMP   $@"
	$(OBJDUMP) --source --all-headers --demangle --line-numbers --wide $(APP_ELF) > $(APP_LST)
	

$(APP_HEX): $(APP_ELF)
	$(ECHO) " OBJCOPY   $@"
	@$(OBJCOPY) -O ihex $(OBJ_FLAGS) $< $@

$(APP_BIN): $(APP_ELF)
	$(ECHO) " OBJCOPY   $@"
	@$(OBJCOPY) -O binary $< $@


$(APP_ELF): $(OBJS)
	$(ECHO) " LD        $@"
	@$(LD) $(OBJS) $(LDFLAGS)  -o $@

$(BINDIR):
	mkdir -p $(BINDIR)



$(BINDIR)/%.o: %.c
	$(ECHO) " CC        $@"
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) $(INCDIRS) $(USER_FLAGS)   -c $< -o $@
	
$(BINDIR)/%.o: %.S
	$(ECHO) " AS        $@"
	@mkdir -p $(dir $@)
	@$(CC) $(ASM_FLAGS) $(INCDIRS) $(USER_FLAGS) -c $< -o $@
	


clean:
	rm -rf $(BINDIR)
