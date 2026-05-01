
# Paths to your symbol and executable files
SYM_FILE  := $(APP_ELF)
EXEC_FILE := $(APP_ELF)
#GDB       := C:\Microchip\SoftConsole-v2021.1\arm-none-eabi-gcc\bin\arm-none-eabi-gdb



GDB_TARGET   = -ex "target remote localhost:3333";
#GDB_COMMANDS = -ex "load"; -ex "monitor halt"; -ex "set mem inaccessible-by-default off" -ex "set remotetimeout 7" -ex "break main"

	
debug: $(APP_ELF)
	@$(GDB) $(APP_ELF) \
	-ex "set $target_riscv = 1" \
	-ex "set mem inaccessible-by-default off" \
	-ex "set arch riscv:rv32" \
	-ex "target remote localhost:3333" \
	-ex "monitor init" \
	-ex "load" \
	-ex "break main" \
	-ex "continue"

debug_new:
	@$(GDB)  \
		-ex "file $(EXEC_FILE)" \
		-ex "symbol-file $(SYM_FILE)" \
		-ex "target remote localhost:3333" \
		-ex "monitor reset halt" \
		-ex "load" \
		-ex "break main" \
		-ex "continue"
debug2:
	@$(GDB) \
		-ex "file $(APP_ELF)"\
		-ex "symbol-file $(SYM_FILE)" \
		-ex "target remote localhost:3333"