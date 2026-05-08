# Libero SmartDesign builder script for PolarFire family hardware platforms
# This builder is targetted at the following soft-CPU configurations:
#
#  MIV_RV32: CFG1 - AHB 
#  MIV_RV32: CFG2 - AXI4
#  MIV_RV32: CFG3 - TCM
#

#Libero's TCL top level script
#
#This Tcl file sources other Tcl files to build the design(on which recursive export is run) in a bottom-up fashion

auto_promote_pad_pins -promote_all 0

#Sourcing the Tcl files for each of the design's components
set cjdRstType [expr {$softCpu eq "MIV_RV32" ? "TRSTN" : "TRST"}]


source $scriptDir/import/components/CoreJTAGDebug_${cjdRstType}_C0.tcl 
source $scriptDir/import/components/CoreTimer_C0.tcl 
#source $scriptDir/import/components/CoreTimer_C1.tcl 
source $scriptDir/import/components/MIV_ESS_C0.tcl 
source $scriptDir/import/components/${softCpu}_${config}_C0.tcl

#import  MSS_DDR Component

import_component -file $scriptDir/import/components/M2S_DDR/MSS_C0/MSS_C0.cxf
generate_component -component_name {MSS_C0} -recursive 0 

import_component -file $scriptDir/import/components/M2S_DDR/MSS_DDR_C0/MSS_DDR_C0.cxf
generate_component -component_name {MSS_DDR_C0} -recursive 0 

build_design_hierarchy 




# Creating SmartDesign BaseDesign
create_smartdesign -sd_name ${sdName}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Ports
sd_create_scalar_port -sd_name ${sdName} -port_name {REF_CLK} -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {TRSTB}   -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {TCK}     -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {TDI}     -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {TMS}     -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {TDO}     -port_direction {OUT}
sd_create_scalar_port -sd_name ${sdName} -port_name {RX}      -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {TX}      -port_direction {OUT}
sd_create_scalar_port -sd_name ${sdName} -port_name {DEVRST_N} -port_direction {IN}

sd_create_scalar_port -sd_name ${sdName} -port_name {SW_1}  -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {SW_2}  -port_direction {IN}
sd_create_scalar_port -sd_name ${sdName} -port_name {LED_1} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sdName} -port_name {LED_2} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sdName} -port_name {LED_3} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sdName} -port_name {LED_4} -port_direction {OUT}


# MIV_RV32 instance setup
sd_instantiate_component -sd_name ${sdName} -component_name "${softCpu}_${config}_C0" -instance_name "${softCpu}_${config}_C0_0"
sd_mark_pins_unused -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:JTAG_TDO_DR"
sd_mark_pins_unused -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:EXT_RESETN"
sd_mark_pins_unused -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:TIME_COUNT_OUT"


# Add MIV_ESS_C0 instance
sd_instantiate_component -sd_name ${sdName} -component_name {MIV_ESS_C0} -instance_name {MIV_ESS_C0_0}
sd_create_pin_slices -sd_name ${sdName} -pin_name {MIV_ESS_C0_0:GPIO_IN} -pin_slices {[0]}
sd_create_pin_slices -sd_name ${sdName} -pin_name {MIV_ESS_C0_0:GPIO_IN} -pin_slices {[1]}
sd_create_pin_slices -sd_name ${sdName} -pin_name {MIV_ESS_C0_0:GPIO_IN} -pin_slices {[3:2]}
sd_connect_pins_to_constant -sd_name ${sdName} -pin_names {MIV_ESS_C0_0:GPIO_IN[3:2]} -value {GND}
sd_create_pin_slices -sd_name ${sdName} -pin_name {MIV_ESS_C0_0:GPIO_OUT} -pin_slices {[0]}
sd_create_pin_slices -sd_name ${sdName} -pin_name {MIV_ESS_C0_0:GPIO_OUT} -pin_slices {[1]}
sd_create_pin_slices -sd_name ${sdName} -pin_name {MIV_ESS_C0_0:GPIO_OUT} -pin_slices {[2]}
sd_create_pin_slices -sd_name ${sdName} -pin_name {MIV_ESS_C0_0:GPIO_OUT} -pin_slices {[3]}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {MIV_ESS_C0_0:GPIO_INT}


# Add CoreTimer_C0 instance
sd_instantiate_component -sd_name ${sdName} -component_name {CoreTimer_C0} -instance_name {CoreTimer_C0_0}


# Add CoreTimer_C1 instance
#sd_instantiate_component -sd_name ${sdName} -component_name {CoreTimer_C1} -instance_name {CoreTimer_C1_0}


# Add CoreJTAGDebug_C0 instance
sd_instantiate_component -sd_name ${sdName} -component_name "CoreJTAGDebug_${cjdRstType}_C0" -instance_name "CoreJTAGDebug_${cjdRstType}_C0_0"



# Add MSS_DDR_C0_0 instance
sd_instantiate_component -sd_name ${sdName} -component_name "MSS_DDR_C0" -instance_name "MSS_DDR_C0_0"

sd_connect_pin_to_port -sd_name ${sdName}  -pin_name {MSS_DDR_C0_0:MDDR_PADS} -port_name {} 
sd_connect_pins_to_constant -sd_name ${sdName} -pin_names {MSS_DDR_C0_0:FAB_RESET_N}   -value {VCC}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {MSS_DDR_C0_0:POWER_ON_RESET_N}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {MSS_DDR_C0_0:INIT_DONE}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {MSS_DDR_C0_0:MSS_READY}
sd_mark_pins_unused -sd_name ${sdName} -pin_names {MSS_DDR_C0_0:MSS_DDR_FIC_SUBSYSTEM_LOCK}



# Connect Clock and Reset Connections

sd_connect_pins -sd_name ${sdName} -pin_names "MSS_DDR_C0_0:CLK0   REF_CLK"
sd_connect_pins -sd_name ${sdName} -pin_names "MSS_DDR_C0_0:DEVRST_N DEVRST_N"

sd_connect_pins -sd_name ${sdName} -pin_names "MSS_DDR_C0_0:DDR_READY ${softCpu}_${config}_C0_0:RESETN"
sd_connect_pins -sd_name ${sdName} -pin_names "MSS_DDR_C0_0:DDR_READY MIV_ESS_C0_0:PRESETN"
sd_connect_pins -sd_name ${sdName} -pin_names "MSS_DDR_C0_0:DDR_READY CoreTimer_C0_0:PRESETn"


sd_connect_pins -sd_name ${sdName} -pin_names "MSS_DDR_C0_0:MSS_DDR_FIC_SUBSYSTEM_CLK CoreTimer_C0_0:PCLK"
sd_connect_pins -sd_name ${sdName} -pin_names "MSS_DDR_C0_0:MSS_DDR_FIC_SUBSYSTEM_CLK MIV_ESS_C0_0:PCLK"
sd_connect_pins -sd_name ${sdName} -pin_names "MSS_DDR_C0_0:MSS_DDR_FIC_SUBSYSTEM_CLK ${softCpu}_${config}_C0_0:CLK"


# CoreJTAG Connections

sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_${cjdRstType}_C0_0:TGT_TCK_0 ${softCpu}_${config}_C0_0:JTAG_TCK"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_${cjdRstType}_C0_0:TGT_TDI_0 ${softCpu}_${config}_C0_0:JTAG_TDI"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_${cjdRstType}_C0_0:TGT_TDO_0 ${softCpu}_${config}_C0_0:JTAG_TDO"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_${cjdRstType}_C0_0:TGT_TMS_0 ${softCpu}_${config}_C0_0:JTAG_TMS"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_${cjdRstType}_C0_0:TGT_${cjdRstType}_0 ${softCpu}_${config}_C0_0:JTAG_${cjdRstType}" 

sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_${cjdRstType}_C0_0:TCK TCK"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_${cjdRstType}_C0_0:TDI TDI"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_${cjdRstType}_C0_0:TDO TDO"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_${cjdRstType}_C0_0:TMS TMS"
sd_connect_pins -sd_name ${sdName} -pin_names "COREJTAGDEBUG_${cjdRstType}_C0_0:TRSTB TRSTB"




# CoreTimer_C0 Connections
sd_connect_pins -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:MSYS_EI CoreTimer_C0_0:TIMINT"
#sd_connect_pins -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:EXT_IRQ CoreTimer_C1_0:TIMINT"


#CoreUART Connections
sd_connect_pins -sd_name ${sdName} -pin_names {"MIV_ESS_C0_0:UART_RX" "RX" }
sd_connect_pins -sd_name ${sdName} -pin_names {"MIV_ESS_C0_0:UART_TX" "TX" }


# GPIO Connections
sd_connect_pins -sd_name ${sdName} -pin_names {"MIV_ESS_C0_0:GPIO_IN[0]" "SW_1" }
sd_connect_pins -sd_name ${sdName} -pin_names {"MIV_ESS_C0_0:GPIO_IN[1]" "SW_2" }
sd_connect_pins -sd_name ${sdName} -pin_names {"MIV_ESS_C0_0:GPIO_OUT[0]" "LED_1" }
sd_connect_pins -sd_name ${sdName} -pin_names {"MIV_ESS_C0_0:GPIO_OUT[1]" "LED_2" }
sd_connect_pins -sd_name ${sdName} -pin_names {"MIV_ESS_C0_0:GPIO_OUT[2]" "LED_3" }
sd_connect_pins -sd_name ${sdName} -pin_names {"MIV_ESS_C0_0:GPIO_OUT[3]" "LED_4" }





# Add bus interface netconnections

sd_connect_pins -sd_name ${sdName} -pin_names {"MIV_ESS_C0_0:APB_3_mTARGET" "CoreTimer_C0_0:APBslave" }
#sd_connect_pins -sd_name ${sdName} -pin_names {"MIV_ESS_C0_0:APB_4_mTARGET" "CoreTimer_C1_0:APBslave" }
sd_connect_pins -sd_name ${sdName} -pin_names "MIV_ESS_C0_0:APB_0_mINITIATOR ${softCpu}_${config}_C0_0:APB_INITIATOR"

sd_connect_pins -sd_name ${sdName} -pin_names "${softCpu}_${config}_C0_0:AHBL_M_TARGET MSS_DDR_C0_0:MDDR_DDR_AMBA_SLAVE"

sd_mark_pins_unused -sd_name {BaseDesign} -pin_names {MIV_ESS_C0_0:APB_4_mTARGET} 




# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Re-arrange SmartDesign layout
sd_reset_layout -sd_name ${sdName}
# Save the smartDesign
save_smartdesign -sd_name ${sdName}
# Generate SmartDesign BaseDesign
generate_component -component_name ${sdName}
