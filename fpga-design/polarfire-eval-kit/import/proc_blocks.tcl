#
# Procedure blocks start

proc print_message {message} {
    set lines [split $message "\n"]
    set maxLength 0
    foreach line $lines {
        set length [string length $line]
        if {$length > $maxLength} {
            set maxLength $length
        }
    }
    set stars [string repeat "*" [expr {$maxLength + 4}]]
    puts "$stars"
    foreach line $lines {
        puts "* $line *"
    }
    puts "$stars"
}

proc print_alternative_message {message} {
	puts "\n-------------------------------------------------------------------------------"
	puts "$message"
	puts "-------------------------------------------------------------------------------"
}


proc safe_source {filename} {
    global scriptDir
    global sdBuildScript
    set errmsg ""
    set result [catch {source [file join $scriptDir $filename]} errmsg]
    if {$result != 0} {
        # Here we use the global ::errorInfo variable to get the error information
        puts stderr "Error in $filename: $errmsg"
        puts stderr "Stack trace: $::errorInfo"
        # Re-raise the error so that the calling script knows there was a problem
        return -code error $errmsg
    }
}


# Procedure to verify the 'config' argument
proc verify_config { config } {
    # Use the global variable 'validConfigs'
    global validConfigs

    # If 'config' is empty, set it to a default value
    if {$config eq ""} {
        set config "CFG1"
        puts "Info: Default 'CFG1' design has been selected."
    # If 'config' is not in the list of valid values, exit the script
    } elseif {[lsearch -exact $validConfigs $config] == -1} {
        puts "Error: Wrong 1st Argument has been entered. No valid configuration detected."
        exit 1
    } else {
        puts "Info: Configuration selected: $config"
    }

    return "$config"
}

proc verify_designFlow { designFlow } {
    # Use the global variable 'validDesignFlows'
    global validDesignFlows

    # If 'designFlow' is "BASE" or empty, set it to a default value
    if {$designFlow eq "" || $designFlow eq "BASE"} {
        set designFlow "BASE"
        puts "Info: No specific Design Flow selected. Default 'BASE' operation will be performed."
    # If 'designFlow' is not in the list of valid values, exit the script
    } elseif {[lsearch -exact $validDesignFlows $designFlow] == -1} {
        puts "Error: Wrong 2nd Argument has been entered. No valid Design Flow detected."
        exit 1
    } else {
        puts "Info: Design flow run tool selected: $designFlow"
    }

    return $designFlow
}

# Procedure to verify the 'dieType' argument
proc verify_dieType { dieType } {
    global validDieTypes

    if {![info exists dieType] || $dieType eq ""} {
        set dieType "PS"
        puts "Info: No die type argument has been entered. Assuming default 'PS'."
    } elseif {[lsearch -exact $validDieTypes $dieType] == -1} {
        puts "Error: Invalid die type argument. Please enter a valid die type."
        exit 1
    } else {
        puts "Info: Die type selected: $dieType"
    }

    return $dieType
}

proc get_config_builder {config validConfigs tclSdRef} {
    set configMapping [dict create]

    foreach validConfig $validConfigs {
        switch -exact -- $validConfig {
            "CFG1" -
            "CFG2" -
            "CFG3" {
                dict set configMapping $validConfig $tclSdRef
            }
            "DGC1" -
            "DGC2" -
            "DGC3" -
            "DGC4" {
                dict set configMapping $validConfig "MIV_ESS"
            }
            default {
                dict set configMapping $validConfig $tclSdRef
            }
        }
    }

    set mappedValue [dict get $configMapping $config]
    if {$mappedValue eq ""} {
        set mappedValue $tclSdRef
    }

    return "${mappedValue}_build_sd.tcl"
}

proc get_legacy_core_name {config coreRef} {

    if { ($config eq "CFG1") && ($coreRef eq "MIV_RV32IMAF")} {
        return "MIV_RV32IMAF_L1_AHB"
    } elseif {($config eq "CFG1") && ($coreRef eq "MIV_RV32IMA")} {
        return "MIV_RV32IMA_L1_AHB"
    } elseif {($config eq "CFG2") && ($coreRef eq "MIV_RV32IMA")} {
        return "MIV_RV32IMA_L1_AXI"
    }
}

proc get_die_configuration { hwPlatform dieType } {

    # Hardware Platforms (other devices require constraints to be matched)
    global diePackage
    global dieSize
    global tempGrade
    global dieSpeed
    global defIOstd
    global hwFamily
    global dieVoltage

    switch $hwPlatform {

	 "M2S_CREATIVE" {
                        set diePackage [expr {$dieType == "PS" ? "M2S025" : "M2S025"}]
                        set dieSize "vf256"
                        set tempGrade [expr {$dieType == "PS" ? "COM" : "COM"}]
                        set dieSpeed "-1"
                        set defIOstd "LVTTL"
			set dieVoltage "1.2"
                        set hwFamily "SmartFusion2"   			
        }
        "PF_EVAL" {
                        set diePackage [expr {$dieType == "PS" ? "MPF300TS" : "MPF300TS_ES"}]
                        set dieSize "FCG1152"
                        set tempGrade [expr {$dieType == "PS" ? "IND" : "EXT"}]
                        set dieSpeed "-1"
                        set defIOstd "LVCMOS18"
			set dieVoltage "1.0"
                        set hwFamily "PolarFire"
        } "PF_AVAL" {
                        set diePackage [expr {$dieType == "PS" ? "MPF300TS" : "MPF300TS_ES"}]
                        set dieSize "FCG484"
                        set tempGrade [expr {$dieType == "PS" ? "IND" : "EXT"}]
                        set dieSpeed "STD"
                        set defIOstd "LVCMOS18"
			set dieVoltage "1.0"
                        set hwFamily "PolarFire"
        } "PF_EVEREST" {
                        set diePackage [expr {$dieType == "PS" ? "MPF300TS" : "MPF300TS_ES"}]
                        set dieSize "FCG1152"
                        set tempGrade [expr {$dieType == "PS" ? "IND" : "EXT"}]
                        set dieSpeed "-1"
                        set defIOstd "LVCMOS18"
                        set hwFamily "PolarFire"
        } "PF_SPLASH" {
                        set diePackage [expr {$dieType == "PS" ? "MPF300TS" : "MPF300TS_ES"}]
                        set dieSize "FCG484"
                        set tempGrade [expr {$dieType == "PS" ? "IND" : "EXT"}]
                        set dieSpeed "-1"
                        set defiostd "LVCMOS18"
			set dieVoltage "1.0"
                        set hwFamily "Polarfire"
        } "RTG4_DEV" {
                        set diePackage "RT4G150"
                        set dieSize "1657 CG"
                        set tempGrade "MIL"
                        set dieSpeed "STD"
                        set defIOstd "LVCMOS18"
			set dieVoltage "1.2"
                        set hwFamily "RTG4"
        } default {
            puts "Error: Invalid hardware platform. Please enter a valid hardware platform."
            exit 1
        }
    }
	    
}

proc download_required_direct_cores  {hwPlatform softCpu config} {
	download_core -vlnv {Actel:DirectCore:CoreUARTapb:5.7.100} -location {www.microchip-ip.com/repositories/DirectCore}
	download_core -vlnv {Actel:DirectCore:CoreTimer:2.0.103} -location {www.microchip-ip.com/repositories/DirectCore}
	download_core -vlnv {Actel:DirectCore:CORERESET_PF:2.3.100} -location {www.microchip-ip.com/repositories/DirectCore}
	download_core -vlnv {Actel:DirectCore:COREJTAGDEBUG:4.0.100} -location {www.microchip-ip.com/repositories/DirectCore}
	download_core -vlnv {Actel:DirectCore:CoreGPIO:3.2.102} -location {www.microchip-ip.com/repositories/DirectCore}
	download_core -vlnv {Actel:DirectCore:COREAXITOAHBL:3.6.101} -location {www.microchip-ip.com/repositories/DirectCore}
	download_core -vlnv {Actel:DirectCore:CoreAPB3:4.2.100} -location {www.microchip-ip.com/repositories/DirectCore}
	download_core -vlnv {Actel:DirectCore:COREAHBTOAPB3:3.2.101} -location {www.microchip-ip.com/repositories/DirectCore}
	download_core -vlnv {Actel:DirectCore:CoreAHBLite:6.1.101} -location {www.microchip-ip.com/repositories/DirectCore}
    if {$softCpu eq "MIV_RV32"} {
        download_core -vlnv {Microsemi:MiV:MIV_RV32:3.2.100} -location {www.microchip-ip.com/repositories/DirectCore} 
        download_core -vlnv {Actel:SystemBuilder:MIV_ESS:2.0.200} -location {www.microchip-ip.com/repositories/SgCore}  
    }
	if {$softCpu eq "MIV_RV32IMA_L1_AHB"} {download_core -vlnv {Microsemi:MiV:MIV_RV32IMA_L1_AHB:2.3.100} -location {www.microchip-ip.com/repositories/DirectCore} }
	if {$softCpu eq "MIV_RV32IMA_L1_AXI"} {download_core -vlnv {Microsemi:MiV:MIV_RV32IMA_L1_AXI:2.1.100} -location {www.microchip-ip.com/repositories/DirectCore} }
	if {$softCpu eq "MIV_RV32IMAF_L1_AHB"} {download_core -vlnv {Microsemi:MiV:MIV_RV32IMAF_L1_AHB:2.1.100} -location {www.microchip-ip.com/repositories/DirectCore} }
}

proc update_param {config param_to_update value_to_set} {
    set config_file [open $config]
    set config_file_data [read $config_file]
    set config_file_lines [split $config_file_data "\n"]
    close $config_file
    set config_file [open $config w]
    foreach line $config_file_lines {
        if { [regexp $param_to_update $line] } {
            puts $config_file "$param_to_update$value_to_set"
            puts $line
        } else {
            puts $config_file "$line"
        }
    }
    close $config_file
}

proc configure_ram_device {scriptDir config sd_name projectDir} {
	# Import RAM.cfg for design initialization memory for Hard-RAM TCM config
	print_message "Generating Design Initialization Data..."
	file copy -force $scriptDir/import/software_example/$config/RAM.cfg ./$projectDir/designer/$sd_name
	configure_ram -cfg_file $projectDir/designer/$sd_name/RAM.cfg
	generate_design_initialization_data
	print_message "Design Initialization Data Generated."
}

proc pre_configure_place_and_route { } {
	# Configuring Place_and_Route tool for a timing pass.
	configure_tool -name {PLACEROUTE} -params {EFFORT_LEVEL:false} -params {REPAIR_MIN_DELAY:true} -params {TDPR:true}
}

proc run_verify_timing { } {
	run_tool -name {VERIFYTIMING}	
}
# Procedure blocks end
#
