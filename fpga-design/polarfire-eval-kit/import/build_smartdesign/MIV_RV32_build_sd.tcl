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

source $scriptDir/import/components/$config/PF_INIT_MONITOR_C0.tcl 
source $scriptDir/import/components/$config/CORERESET_PF_C0.tcl 
source $scriptDir/import/components/$config/PF_CCC_C0.tcl
source $scriptDir/import/components/$config/CoreJTAGDebug_${cjdRstType}_C0.tcl
source $scriptDir/import/components/$config/PF_SRAM_AHB_C0.tcl 
source $scriptDir/import/components/$config/MIV_RV32_${config}_C0.tcl


# APB Peripherals for CFG1 

if {$config eq "CFG1"} {
source $scriptDir/import/components/$config/CoreTimer_C0.tcl
source $scriptDir/import/components/$config/CoreTimer_C1.tcl
source $scriptDir/import/components/$config/CoreUARTapb_C0.tcl
source $scriptDir/import/components/$config/CORESPI_C0.tcl
source $scriptDir/import/components/$config/CoreGPIO_C0.tcl
source $scriptDir/import/components/$config/CoreGPIO_C1.tcl
source $scriptDir/import/components/$config/CoreAPB3_C0.tcl
source $scriptDir/import/components/$config/APB_PERIPHERALS.tcl

}

# MIV_ESS for CFG2 
if {$config eq "CFG2"} {
    source $scriptDir/import/components/$config/MIV_ESS_${config}_C0.tcl
}

source $scriptDir/import/components/$config/CLOCK_AND_RESET.tcl
source $scriptDir/import/components/$config/Basedesign.tcl


