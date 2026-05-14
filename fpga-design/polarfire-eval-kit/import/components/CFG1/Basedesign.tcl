# Creating SmartDesign "MPF_EVAL_RV32_DEMO"
set sd_name {Basedesign}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {EXT_RST_N} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {FLASH_SDI} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {REF_CLK_50MHZ} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RX} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SW1} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SW2} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TCK} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TDI} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TMS} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TRSTB} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {FLASH_HOLDn} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {FLASH_SCK} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {FLASH_SDO} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {FLASH_SS} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED1} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED2} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED3} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED4} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TDO} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TX} -port_direction {OUT}

sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {FLASH_HOLDn} -value {VCC}


# Add APB_PERIPHERALS_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {APB_PERIPHERALS} -instance_name {APB_PERIPHERALS_0}



# Add CLOCK_AND_RESET_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CLOCK_AND_RESET} -instance_name {CLOCK_AND_RESET_0}



# Add CoreJTAGDebug_TRSTN_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CoreJTAGDebug_TRSTN_C0} -instance_name {CoreJTAGDebug_TRSTN_C0_0}



# Add MIV_RV32_CFG1_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {MIV_RV32_CFG1_C0} -instance_name {MIV_RV32_CFG1_C0_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_RV32_CFG1_C0_0:MSYS_EI} -pin_slices {[0:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_RV32_CFG1_C0_0:MSYS_EI} -pin_slices {[1:1]}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {MIV_RV32_CFG1_C0_0:EXT_RESETN}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {MIV_RV32_CFG1_C0_0:JTAG_TDO_DR}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {MIV_RV32_CFG1_C0_0:TIME_COUNT_OUT}



# Add PF_SRAM_AHB_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PF_SRAM_AHB_C0} -instance_name {PF_SRAM_AHB_C0_0}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_PERIPHERALS_0:LED1" "LED1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_PERIPHERALS_0:LED2" "LED2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_PERIPHERALS_0:LED3" "LED3" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_PERIPHERALS_0:LED4" "LED4" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_PERIPHERALS_0:PCLK" "CLOCK_AND_RESET_0:CLK_50MHZ" "MIV_RV32_CFG1_C0_0:CLK" "PF_SRAM_AHB_C0_0:HCLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_PERIPHERALS_0:PRESETn" "CLOCK_AND_RESET_0:FABRIC_RESET_N" "MIV_RV32_CFG1_C0_0:RESETN" "PF_SRAM_AHB_C0_0:HRESETN" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_PERIPHERALS_0:RX" "RX" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_PERIPHERALS_0:SPISCLKO" "FLASH_SCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_PERIPHERALS_0:SPISDI" "FLASH_SDI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_PERIPHERALS_0:SPISDO" "FLASH_SDO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_PERIPHERALS_0:SPISS" "FLASH_SS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_PERIPHERALS_0:SW1" "SW1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_PERIPHERALS_0:SW2" "SW2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_PERIPHERALS_0:TIMINT_0" "MIV_RV32_CFG1_C0_0:MSYS_EI[0:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_PERIPHERALS_0:TIMINT_1" "MIV_RV32_CFG1_C0_0:MSYS_EI[1:1]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_PERIPHERALS_0:TX" "TX" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLOCK_AND_RESET_0:EXT_RST_N" "EXT_RST_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLOCK_AND_RESET_0:REF_CLK_0" "REF_CLK_50MHZ" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TCK" "TCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TDI" "TDI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TDO" "TDO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TGT_TCK_0" "MIV_RV32_CFG1_C0_0:JTAG_TCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TGT_TDI_0" "MIV_RV32_CFG1_C0_0:JTAG_TDI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TGT_TDO_0" "MIV_RV32_CFG1_C0_0:JTAG_TDO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TGT_TMS_0" "MIV_RV32_CFG1_C0_0:JTAG_TMS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TGT_TRSTN_0" "MIV_RV32_CFG1_C0_0:JTAG_TRSTN" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TMS" "TMS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TRSTB" "TRSTB" }


# Add bus interface net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_PERIPHERALS_0:APB3mmaster" "MIV_RV32_CFG1_C0_0:APB_INITIATOR" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_RV32_CFG1_C0_0:AHBL_M_TARGET" "PF_SRAM_AHB_C0_0:AHBSlaveInterface" }

# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the SmartDesign 
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign "MPF_EVAL_RV32_DEMO"
generate_component -component_name ${sd_name}
