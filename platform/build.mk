#
# Makefile for Cortex-M3 
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


OUT 	    ?= firmware
TARGET_NAME ?=firmware
BUILD_DIR   ?= build
OBJ_DIR     ?= $(BUILD_DIR)/obj


CC      = riscv64-unknown-elf-gcc
CP      = riscv64-unknown-elf-objcopy
AS      = riscv64-unknown-elf-gcc -x assembler-with-cpp
SIZE    = riscv64-unknown-elf-size
OBJDUMP = riscv64-unknown-elf-objdump



# User's application include folders (don't forget the '-I' before each entry)
APP_INC ?= -I .
# User's application include folders - for assembly files only (don't forget the '-I' before each entry)
ASM_INC ?= -I .

USER_FLAGS ?= 

CORE_SRC := src/platform/hal/hal_irq.c \
	        src/platform/miv_rv32_hal/miv_rv32_hal.c \
	        src/platform/miv_rv32_hal/miv_rv32_init.c \
	        src/platform/miv_rv32_hal/miv_rv32_stubs.c \
	        src/platform/miv_rv32_hal/miv_rv32_syscall.c
        		

ASM_SRCS  += src/platform/miv_rv32_hal/miv_rv32_entry.S \
	         src/platform/hal/hw_reg_access.S

CORE_INC += -I . \
		   -I src/application \
		   -I src/middleware \
		   -I src/platform \
		   -I src/boards/$(TARGET_BOARD)

CORE_INC += -I src/platform/hal \
            -I src/platform/miv_rv32_hal 

# Define all sources

C_SRCS     += $(CORE_SRC)
C_SRCS     += $(APP_SRCS)
C_SRCS     += $(DRIVER_SRC)


## below is to avoid error if the user application doesn't include any assembly files
#ifdef APP_ASM
ASM_SRCS +=$(APP_ASM)
#endif


INCDIRS  +=$(CORE_INC)
INCDIRS  +=$(INCS)
INCDIRS  +=$(DRIVER_INC)


# Define all object files

# this create the object files into the build directory instead of the source folder.
# the vpath provides a virtual path of each source file inside the build folder 

OBJS = $(addprefix $(OBJ_DIR)/,$(notdir $(C_SRCS:.c=.o)))
vpath %.c $(sort $(dir $(C_SRCS)))

OBJS += $(addprefix $(OBJ_DIR)/,$(notdir $(ASM_SRCS:.S=.o)))
vpath %.S $(sort $(dir $(ASM_SRCS)))

# if no linker file specified in the user Makefile, use the default linker file
#LDFILE ?= boards/m2s025-creative-board/platform_config/linker/miv-rv32-ram.ld


# Target output file names
APP_BIN  = $(TARGET_NAME).bin
APP_ELF  = $(TARGET_NAME).elf
APP_HEX  = $(TARGET_NAME).hex
APP_LST  = $(TARGET_NAME).lst
APP_MAP  = $(TARGET_NAME).map


#-------------------- Compile and Linking options -----------------------------#
# C Source compile options
CFLAGS	  := -march=rv32i -mabi=ilp32 -g3 -std=gnu11
CFLAGS    += --specs=nano.specs
CFLAGS    += -mcmodel=medany 
CFLAGS    += -msmall-data-limit=8  
CFLAGS    += -mstrict-align -mno-save-restore -O0
CFLAGS	  += -fmessage-length=0 -fsigned-char -fdata-sections -ffunction-sections  


# Linking options 
LDFLAGS   := -march=rv32i -mabi=ilp32 -g3
LDFLAGS   += -mcmodel=medany
LDFLAGS   += -msmall-data-limit=8
LDFLAGS   += -mstrict-align -mno-save-restore -O0
LDFLAGS   += -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections 
LDFLAGS   += -T$(LDFILE) 
LDFLAGS	  += -Xlinker --gc-sections -nostartfiles --specs=nano.specs 


# optional option to print te ram,flash utilisation
LDFLAGS   +=-Wl,-Map,$(BUILD_DIR)/$(APP_MAP)

# assembly files  compile options
ASM_FLAGS := -march=rv32i -mabi=ilp32 -g3 -x assembler-with-cpp
ASM_FLAGS += -mcmodel=medany 
ASM_FLAGS += -msmall-data-limit=8
ASM_FLAGS += -mstrict-align -mno-save-restore -O0
ASM_FLAGS += -fmessage-length=0 -fsigned-char -fdata-sections -ffunction-sections 


LIBS ?=


# below are the build list for easy access. 
# COMPILE_DIR has to be created before evry other call
#asm:     $(BUILD_DIR) $(APP_ASM)
elf:     $(OBJ_DIR) $(APP_ELF)
exe:     $(OBJ_DIR) $(APP_EXE)
hex:     $(OBJ_DIR) $(APP_HEX)
bin:     $(BUILD_DIR) $(APP_BIN)
lst:     $(BUILD_DIR) $(APP_LST)



all: elf hex bin


$(APP_LST):$(APP_ELF)
	@echo 'Cross ARM GNU Create Listing'
	$(OBJDUMP) --source --all-headers --demangle --line-numbers --wide $(BUILD_DIR)/$(APP_ELF) > $(BUILD_DIR)/$(APP_LST)
	@echo 'Finished building: $@'
	@echo ' '
	
$(APP_HEX):$(APP_ELF)
	@echo 'Invoking: GNU ARM Cross Create Flash Image '
	$(CP) -O ihex  $(BUILD_DIR)/$(APP_ELF)  $(BUILD_DIR)/$(APP_HEX)
	$(SIZE) --format=berkeley $(BUILD_DIR)/$(APP_ELF)
	$(SIZE) --format=sysv --radix=16 $(BUILD_DIR)/$(APP_ELF)
	@echo 'Finished building: $@'
	@echo ' '
$(APP_BIN):$(APP_ELF)
	@echo 'Invoking: GNU ARM Cross Create Flash Image'
	$(CP) -O binary  $(BUILD_DIR)/$(APP_ELF)  $(BUILD_DIR)/$(APP_BIN)
	@echo 'Finished building: $@'
	@echo ' '

$(APP_ELF): $(OBJS)
	@echo 'Invoking: GNU ARM Cross C Linker'
	$(CC) $(LDFLAGS)  -o $(BUILD_DIR)/$(APP_ELF) $(OBJS)
	$(SIZE) --format=berkeley $^
	@echo 'Finished building: $@'
	@echo ' '



$(OBJ_DIR):
	mkdir -p $(BUILD_DIR)
	mkdir -p $(OBJ_DIR)

$(OBJ_DIR)/%.o: %.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM Cross C Compiler'
	$(CC) $(CFLAGS) $(INCDIRS) $(USER_FLAGS) -c $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(OBJ_DIR)/%.o: %.S
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM Cross Assembler'
	$(AS) $(ASM_FLAGS) $(INCDIRS) $(USER_FLAGS)  -c $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

flash:
	dfu-util -d 28e9:0189 -a 0 --dfuse-address 0x08000000:leave -D $(BUILD_DIR)/$(OUT).bin

clean:
	rm -rf $(BUILD_DIR)
