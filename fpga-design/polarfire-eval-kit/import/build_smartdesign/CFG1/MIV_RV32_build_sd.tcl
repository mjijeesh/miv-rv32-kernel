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

#Sourcing the Tcl files for each of the design's components
set cjdRstType [expr {$softCpu eq "MIV_RV32" ? "TRSTN" : "TRST"}]

source $scriptDir/$config/components/PF_INIT_MONITOR_C0.tcl
source $scriptDir/$config/components/CORERESET_PF_C0.tcl
source $scriptDir/$config/components/PF_CCC_C0.tcl
source $scriptDir/$config/components/CoreJTAGDebug_${cjdRstType}_C0.tcl
source $scriptDir/$config/components/CoreTimer_C0.tcl
source $scriptDir/$config/components/CoreGPIO_C0.tcl
source $scriptDir/$config/components/CoreGPIO_C1.tcl
source $scriptDir/$config/components/CoreTimer_C1.tcl
source $scriptDir/$config/components/CoreUARTapb_C0.tcl
source $scriptDir/$config/components/CoreAPB3_C0.tcl
source $scriptDir/$config/components/CORESPI_C0.tcl
source $scriptDir/$config/components/PF_SRAM_AHB_C0.tcl
source $scriptDir/$config/components/MIV_RV32_CFG1_C0.tcl



# smartdesign blocks

source $scriptDir/$config/APB_PERIPHERALS.tcl
source $scriptDir/$config/CLOCK_AND_RESET.tcl
source $scriptDir/$config/MPF_EVAL_RV32_DEMO.tcl


