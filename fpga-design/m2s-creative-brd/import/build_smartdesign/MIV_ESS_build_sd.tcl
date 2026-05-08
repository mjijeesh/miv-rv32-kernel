# Libero SmartDesign builder script for PolarFire family hardware platforms
# This builder is targetted at the following soft-CPU configurations:
#
# DGC1 MIV_ESS: SPI-Boot
# DGC3 MIV_ESS: uPROM-Boot
# DGC4 MIV_ESS: Base Peripherals
#

#Libero's TCL top level script
#
#This Tcl file sources other Tcl files to build the design(on which recursive export is run) in a bottom-up fashion

#Sourcing the Tcl files for each of the design's components
set cjdRstType [expr {$softCpu eq "MIV_RV32" ? "TRSTN" : "TRST"}]

#source $scriptDir/import/components/CORERESET_PF_C0.tcl 
#source $scriptDir/import/components/PF_CCC_C0.tcl
#source $scriptDir/import/components/PF_INIT_MONITOR_C0.tcl 
source $scriptDir/import/components/dgc/COREJTAGDEBUG_C0.tcl 
source $scriptDir/import/components/dgc/MIV_ESS_${config}_C0.tcl 
source $scriptDir/import/components/dgc/${softCpu}_${config}_C0.tcl
if {$config eq "DGC1"} {
	set sramMemComp "SRC_MEM"
	source $scriptDir/import/components/dgc/${sramMemComp}_C0.tcl
} elseif {$config eq "DGC3"} {
	set sramMemComp "PF_SRAM_AHBL_AXI"
	source $scriptDir/import/components/dgc/${sramMemComp}_C0.tcl
	source $scriptDir/import/components/dgc/PF_UPROM_C0.tcl
} elseif {$config eq "DGC4"} {
	set sramMemComp "PF_SRAM_AHBL_AXI"
	source $scriptDir/import/components/dgc/${sramMemComp}_C0.tcl
	source $scriptDir/import/components/CoreTimer_C0.tcl
	source $scriptDir/import/components/CoreTimer_C1.tcl 
}

# Creating SmartDesign BaseDesign
create_smartdesign -sd_name ${sdName}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
# Create top level Scalar Ports
if {$config eq "DGC1"} {
	sd_create_scalar_port -sd_name ${sdName} -port_name {BOOTSTRAP_BYPASS} -port_direction {IN} 
	sd_create_scalar_port -sd_name ${sdName} -port_name {SYS_RESET_REQ} -port_direction {IN}
	sd_create_scalar_port -sd_name ${sdName} -port_name {FLASH_SDI} -port_direction {IN}
	sd_create_scalar_port -sd_name ${sdName} -port_name {FLASH_SCK} -port_direction {OUT}
	sd_create_scalar_port -sd_name ${sdName} -port_name {FLASH_SDO} -port_direction {OUT}
	sd_create_scalar_port -sd_name ${sdName} -port_name {FLASH_SS} -port_direction {OUT} 
	sd_create_scalar_port -sd_name ${sdName} -port_name {PF_IO_SPI_HOLDn} -port_direction {OUT} 
}
if {$config eq "DGC3"} {
	sd_create_scalar_port -sd_name ${sdName} -port_name {BOOTSTRAP_BYPASS} -port_direction {IN} 
	sd_create_scalar_port -sd_name ${sdName} -port_name {SYS_RESET_REQ} -port_direction {IN} 
}

sd_create_scalar_port -sd_name ${sdName} -port_name {REF_CLK} -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {USER_RST} -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {RX} -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {TX} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sdName} -port_name {TCK} -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {TDI} -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {TMS} -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {TRSTB} -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {TDO} -port_direction {OUT}

# Create top level Bus Ports
sd_create_bus_port -sd_name ${sdName} -port_name {GPIO_IN} -port_direction {IN} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sdName} -port_name {GPIO_OUT} -port_direction {OUT} -port_range {[3:0]}


# MIV_RV32_DGC(n)_C0 instance setup
sd_instantiate_component -sd_name ${sdName} -component_name "${softCpu}_${config}_C0" -instance_name "${softCpu}_${config}_C0_0"
sd_mark_pins_unused -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:JTAG_TDO_DR"
sd_mark_pins_unused -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:EXT_RESETN"
sd_mark_pins_unused -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:TIME_COUNT_OUT"
sd_create_pin_slices -sd_name ${sdName} -pin_name "${softCpu}_${config}_C0_0:MSYS_EI" -pin_slices {[0:0]}
sd_create_pin_slices -sd_name ${sdName} -pin_name "${softCpu}_${config}_C0_0:MSYS_EI" -pin_slices {[1:5]}
sd_connect_pins_to_constant -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:MSYS_EI\[1:5\]" -value {GND}
sd_mark_pins_unused -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:JTAG_TDO_DR"
sd_mark_pins_unused -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:EXT_RESETN"
sd_mark_pins_unused -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:TIME_COUNT_OUT"
if {$config in {"DGC1" "DGC3"}} {sd_connect_pins_to_constant -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:EXT_IRQ" -value {GND} }
if {$config eq "DGC3"} {sd_connect_pins_to_constant -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:MSYS_EI\[0:0\]" -value {GND} }


#Add MSS_DDR Component

if {$hwPlatform eq "M2S_CREATIVE"} {
 #import_component -file $scriptDir/import/components/dgc/MSS_DDR_SYS/DDR_MSS_SYS.cxz
	import_files -convert_EDN_to_HDL 0 -library {work} \
         -cxz $scriptDir/import/components/dgc/MSS_DDR_SYS/DDR_MSS_SYS.cxz
 }



# Add MIV_ESS_DGC(n)_C0 instance
sd_instantiate_component -sd_name ${sdName} -component_name "MIV_ESS_${config}_C0" -instance_name "MIV_ESS_${config}_C0_0"
sd_create_pin_slices -sd_name ${sdName} -pin_name "MIV_ESS_${config}_C0_0:GPIO_IN" -pin_slices {[1:0]}
sd_create_pin_slices -sd_name ${sdName} -pin_name "MIV_ESS_${config}_C0_0:GPIO_IN" -pin_slices {[3:2]}
sd_connect_pins_to_constant -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:GPIO_IN\[3:2\]" -value {GND}
sd_mark_pins_unused -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:GPIO_INT"
if {$config in {"DGC1" "DGC3"}} {sd_invert_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:SYS_RESET_REQ" }
if {$config eq "DGC1"} {sd_connect_pins_to_constant -sd_name ${sdName} -pin_names {PF_IO_SPI_HOLDn} -value {VCC} }


# Add CORERESET_PF_C0_0 instance
if {$hwFamily eq "Polarfire"} {
sd_instantiate_component -sd_name ${sdName} -component_name {CORERESET_PF_C0} -instance_name {CORERESET_PF_C0_0}
sd_connect_pins_to_constant -sd_name ${sdName} -pin_names {CORERESET_PF_C0_0:BANK_x_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sdName} -pin_names {CORERESET_PF_C0_0:BANK_y_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sdName} -pin_names {CORERESET_PF_C0_0:SS_BUSY} -value {GND}
sd_connect_pins_to_constant -sd_name ${sdName} -pin_names {CORERESET_PF_C0_0:FF_US_RESTORE} -value {GND}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {CORERESET_PF_C0_0:PLL_POWERDOWN_B}
}

# Add PF_INIT_MONITOR_C0_0 instance
if {$hwFamily eq "Polarfire"} {
sd_instantiate_component -sd_name ${sdName} -component_name {PF_INIT_MONITOR_C0} -instance_name {PF_INIT_MONITOR_C0_0}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:PCIE_INIT_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:USRAM_INIT_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:SRAM_INIT_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:XCVR_INIT_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:USRAM_INIT_FROM_SNVM_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:USRAM_INIT_FROM_UPROM_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:USRAM_INIT_FROM_SPI_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:SRAM_INIT_FROM_SNVM_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:SRAM_INIT_FROM_UPROM_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:SRAM_INIT_FROM_SPI_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {PF_INIT_MONITOR_C0_0:AUTOCALIB_DONE}
}

# Add PF_CCC_C0 instance
if {$hwFamily eq "Polarfire"} {
sd_instantiate_component -sd_name ${sdName}  -component_name {PF_CCC_C0} -instance_name {PF_CCC_C0_0}
}

# Add Clock Buffer Macro for ref clock
if {$hwFamily eq "Polarfire"} {
sd_instantiate_macro -sd_name ${sdName} -macro_name {CLKBUF} -instance_name {CLKBUF_0} 
}

# Add CoreTimer_C0 instance
if {$config eq "DGC4"} {sd_instantiate_component -sd_name ${sdName} -component_name {CoreTimer_C0} -instance_name {CoreTimer_C0_0} }


# Add CoreTimer_C1 instance
if {$config eq "DGC4"} {sd_instantiate_component -sd_name ${sdName} -component_name {CoreTimer_C1} -instance_name {CoreTimer_C1_0} }


# Add COREJTAGDEBUG_C0_0 instance
sd_instantiate_component -sd_name ${sdName} -component_name {COREJTAGDEBUG_C0} -instance_name {COREJTAGDEBUG_C0_0}


# Add SRAM component instance
sd_instantiate_component -sd_name ${sdName} -component_name "${sramMemComp}_C0" -instance_name "${sramMemComp}_C0_0"


# Config specific components

# DGC3: # Add PF_UPROM_C0_0 instance
if {$hwFamily eq "RTG4"} {
if {$config eq "DGC3"} {sd_instantiate_component -sd_name ${sdName} -component_name {PF_UPROM_C0} -instance_name {PF_UPROM_C0_0} }
}

# DGC design specific connections
if {$config eq "DGC1"} {
	# Add scalar net connections
	sd_connect_pins -sd_name ${sdName} -pin_names "BOOTSTRAP_BYPASS MIV_ESS_${config}_C0_0:BOOTSTRAP_BYPASS" 
	sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:CPU_ACCESS_DISABLE ${softCpu}_${config}_C0_0:TCM_CPU_ACCESS_DISABLE"
	sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:TAS_ACCESS_DISABLE ${softCpu}_${config}_C0_0:TCM_TAS_ACCESS_DISABLE"
	sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:CPU_RESETN ${softCpu}_${config}_C0_0:RESETN"
	sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:SYS_RESET_REQ SYS_RESET_REQ"
	sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:SPI_IRQ ${softCpu}_${config}_C0_0:MSYS_EI\[0:0\]" 
	sd_connect_pins -sd_name ${sdName} -pin_names "FLASH_SCK MIV_ESS_${config}_C0_0:SPI_SCK" 
	sd_connect_pins -sd_name ${sdName} -pin_names "FLASH_SDI MIV_ESS_${config}_C0_0:SPI_SDI" 
	sd_connect_pins -sd_name ${sdName} -pin_names "FLASH_SDO MIV_ESS_${config}_C0_0:SPI_SDO" 
	sd_connect_pins -sd_name ${sdName} -pin_names "FLASH_SS MIV_ESS_${config}_C0_0:SPI_SS" 
	# Add bus interface and net connections
	sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:TAS_APB_mTARGET ${softCpu}_${config}_C0_0:TAS_APB_TARGET"

} elseif {$config eq "DGC3"} {
	# Add scalar net connections
	sd_connect_pins -sd_name ${sdName} -pin_names "BOOTSTRAP_BYPASS MIV_ESS_${config}_C0_0:BOOTSTRAP_BYPASS" 
	sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:CPU_ACCESS_DISABLE ${softCpu}_${config}_C0_0:TCM_CPU_ACCESS_DISABLE"
	sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:TAS_ACCESS_DISABLE ${softCpu}_${config}_C0_0:TCM_TAS_ACCESS_DISABLE"
	sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:CPU_RESETN ${softCpu}_${config}_C0_0:RESETN"
	sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:SYS_RESET_REQ SYS_RESET_REQ"
	sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:BOOT_BLK_PF PF_UPROM_C0_0:BLK"
	sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:BOOT_BUSY_PF PF_UPROM_C0_0:BUSY" 
	# Add bus interface and net connections
	sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:BOOT_ADDR_PF PF_UPROM_C0_0:ADDR"
	sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:BOOT_DATAR_PF PF_UPROM_C0_0:DATAR"
	sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:TAS_APB_mTARGET ${softCpu}_${config}_C0_0:TAS_APB_TARGET"

} elseif {$config eq "DGC4"} {
	# Add scalar net connections
	sd_connect_pins -sd_name ${sdName} -pin_names "CORERESET_PF_C0_0:FABRIC_RESET_N ${softCpu}_${config}_C0_0:RESETN"
	sd_connect_pins -sd_name ${sdName} -pin_names "PF_CCC_C0_0:OUT0_FABCLK_0 CoreTimer_C0_0:PCLK" 
	sd_connect_pins -sd_name ${sdName} -pin_names "PF_CCC_C0_0:OUT0_FABCLK_0 CoreTimer_C1_0:PCLK" 
	sd_connect_pins -sd_name ${sdName} -pin_names "CORERESET_PF_C0_0:FABRIC_RESET_N CoreTimer_C0_0:PRESETn"
	sd_connect_pins -sd_name ${sdName} -pin_names "CORERESET_PF_C0_0:FABRIC_RESET_N CoreTimer_C1_0:PRESETn" 
	sd_connect_pins -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:MSYS_EI\[0:0\] CoreTimer_C0_0:TIMINT"
	sd_connect_pins -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:EXT_IRQ CoreTimer_C1_0:TIMINT"
	# Add bus interface and net connections
	sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:APB_3_mTARGET CoreTimer_C0_0:APBslave" 
	sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:APB_4_mTARGET CoreTimer_C1_0:APBslave"
}

# Add scalar net connections
#sd_connect_pins -sd_name ${sdName} -pin_names {"CLKBUF_0:Y" "PF_CCC_C0_0:REF_CLK_0"} 
#sd_connect_pins -sd_name ${sdName} -pin_names {"CLKBUF_0:PAD" "REF_CLK"}
#sd_connect_pins -sd_name ${sdName} -pin_names {"PF_CCC_C0_0:OUT0_FABCLK_0" "CORERESET_PF_C0_0:CLK"}
#sd_connect_pins -sd_name ${sdName} -pin_names {"PF_CCC_C0_0:PLL_LOCK_0" "CORERESET_PF_C0_0:PLL_LOCK" }
#sd_connect_pins -sd_name ${sdName} -pin_names "PF_CCC_C0_0:OUT0_FABCLK_0 ${softCpu}_${config}_C0_0:CLK" 
#sd_connect_pins -sd_name ${sdName} -pin_names "PF_CCC_C0_0:OUT0_FABCLK_0 MIV_ESS_${config}_C0_0:PCLK"
#sd_connect_pins -sd_name ${sdName} -pin_names "PF_CCC_C0_0:OUT0_FABCLK_0 ${sramMemComp}_C0_0:HCLK" 
#sd_connect_pins -sd_name ${sdName} -pin_names "CORERESET_PF_C0_0:FABRIC_RESET_N ${sramMemComp}_C0_0:HRESETN"

#sd_connect_pins -sd_name ${sdName} -pin_names {"USER_RST" "CORERESET_PF_C0_0:EXT_RST_N"}
#sd_connect_pins -sd_name ${sdName} -pin_names "CORERESET_PF_C0_0:FABRIC_RESET_N MIV_ESS_${config}_C0_0:PRESETN"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TGT_TCK_0 ${softCpu}_${config}_C0_0:JTAG_TCK"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TGT_TDI_0 ${softCpu}_${config}_C0_0:JTAG_TDI"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TGT_TDO_0 ${softCpu}_${config}_C0_0:JTAG_TDO"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TGT_TMS_0 ${softCpu}_${config}_C0_0:JTAG_TMS"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TGT_${cjdRstType}_0 ${softCpu}_${config}_C0_0:JTAG_${cjdRstType}" 
#sd_connect_pins -sd_name ${sdName} -pin_names {"CORERESET_PF_C0_0:FPGA_POR_N" "PF_INIT_MONITOR_C0_0:FABRIC_POR_N" }
#sd_connect_pins -sd_name ${sdName} -pin_names {"CORERESET_PF_C0_0:INIT_DONE" "PF_INIT_MONITOR_C0_0:DEVICE_INIT_DONE" }
sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:UART_RX RX" 
sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:UART_TX TX" 

sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TCK TCK"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TDI TDI"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TDO TDO"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TMS TMS"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_C0_0:TRSTB TRSTB"

# Add bus net connections
sd_connect_pins -sd_name ${sdName} -pin_names "GPIO_IN MIV_ESS_${config}_C0_0:GPIO_IN\[1:0\]" 
sd_connect_pins -sd_name ${sdName} -pin_names "GPIO_OUT MIV_ESS_${config}_C0_0:GPIO_OUT" 

# Add bus interface netconnections
sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_${config}_C0_0:APB_0_mINITIATOR ${softCpu}_${config}_C0_0:APB_INITIATOR"
sd_connect_pins -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:AHBL_M_TARGET ${sramMemComp}_C0_0:AHBSlaveInterface"

# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Re-arrange SmartDesign layout
sd_reset_layout -sd_name ${sdName}
# Save the smartDesign
save_smartdesign -sd_name ${sdName}
# Generate SmartDesign BaseDesign
generate_component -component_name ${sdName}
