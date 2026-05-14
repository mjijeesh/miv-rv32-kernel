# Creating SmartDesign "Basedesign"
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
# Add CLOCK_AND_RESET_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CLOCK_AND_RESET} -instance_name {CLOCK_AND_RESET_0}



# Add CoreJTAGDebug_TRSTN_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CoreJTAGDebug_TRSTN_C0} -instance_name {CoreJTAGDebug_TRSTN_C0_0}



# Add MIV_ESS_CFG2_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {MIV_ESS_CFG2_C0} -instance_name {MIV_ESS_CFG2_C0_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_ESS_CFG2_C0_0:GPIO_IN} -pin_slices {[0:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_ESS_CFG2_C0_0:GPIO_IN} -pin_slices {[1:1]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_ESS_CFG2_C0_0:GPIO_IN} -pin_slices {[2:2]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {MIV_ESS_CFG2_C0_0:GPIO_IN[2:2]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_ESS_CFG2_C0_0:GPIO_IN} -pin_slices {[3:3]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {MIV_ESS_CFG2_C0_0:GPIO_IN[3:3]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_ESS_CFG2_C0_0:GPIO_OUT} -pin_slices {[0:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_ESS_CFG2_C0_0:GPIO_OUT} -pin_slices {[1:1]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_ESS_CFG2_C0_0:GPIO_OUT} -pin_slices {[2:2]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_ESS_CFG2_C0_0:GPIO_OUT} -pin_slices {[3:3]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {MIV_ESS_CFG2_C0_0:WDOG_HALT} -value {VCC}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {MIV_ESS_CFG2_C0_0:TIMER_COUNT_OUT}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {MIV_ESS_CFG2_C0_0:GPIO_INT}



# Add MIV_RV32_CFG2_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {MIV_RV32_CFG1_C0} -instance_name {MIV_RV32_CFG2_C0_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_RV32_CFG2_C0_0:MSYS_EI} -pin_slices {[0:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_RV32_CFG2_C0_0:MSYS_EI} -pin_slices {[1:1]}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {MIV_RV32_CFG2_C0_0:EXT_RESETN}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {MIV_RV32_CFG2_C0_0:JTAG_TDO_DR}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {MIV_RV32_CFG2_C0_0:TIME_COUNT_OUT}



# Add PF_SRAM_AHB_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PF_SRAM_AHB_C0} -instance_name {PF_SRAM_AHB_C0_0}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLOCK_AND_RESET_0:CLK_50MHZ" "MIV_ESS_CFG2_C0_0:PCLK" "MIV_RV32_CFG2_C0_0:CLK" "PF_SRAM_AHB_C0_0:HCLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLOCK_AND_RESET_0:EXT_RST_N" "EXT_RST_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLOCK_AND_RESET_0:FABRIC_RESET_N" "MIV_ESS_CFG2_C0_0:PRESETN" "MIV_RV32_CFG2_C0_0:RESETN" "PF_SRAM_AHB_C0_0:HRESETN" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLOCK_AND_RESET_0:REF_CLK_0" "REF_CLK_50MHZ" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TCK" "TCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TDI" "TDI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TDO" "TDO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TGT_TCK_0" "MIV_RV32_CFG2_C0_0:JTAG_TCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TGT_TDI_0" "MIV_RV32_CFG2_C0_0:JTAG_TDI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TGT_TDO_0" "MIV_RV32_CFG2_C0_0:JTAG_TDO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TGT_TMS_0" "MIV_RV32_CFG2_C0_0:JTAG_TMS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TGT_TRSTN_0" "MIV_RV32_CFG2_C0_0:JTAG_TRSTN" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TMS" "TMS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_TRSTN_C0_0:TRSTB" "TRSTB" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"FLASH_SCK" "MIV_ESS_CFG2_C0_0:SPI_SCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"FLASH_SDI" "MIV_ESS_CFG2_C0_0:SPI_SDI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"FLASH_SDO" "MIV_ESS_CFG2_C0_0:SPI_SDO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"FLASH_SS" "MIV_ESS_CFG2_C0_0:SPI_SS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"LED1" "MIV_ESS_CFG2_C0_0:GPIO_OUT[0:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"LED2" "MIV_ESS_CFG2_C0_0:GPIO_OUT[1:1]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"LED3" "MIV_ESS_CFG2_C0_0:GPIO_OUT[2:2]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"LED4" "MIV_ESS_CFG2_C0_0:GPIO_OUT[3:3]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_CFG2_C0_0:GPIO_IN[0:0]" "SW1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_CFG2_C0_0:GPIO_IN[1:1]" "SW2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_CFG2_C0_0:SPI_IRQ" "MIV_RV32_CFG2_C0_0:MSYS_EI[1:1]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_CFG2_C0_0:TIMER_IRQ" "MIV_RV32_CFG2_C0_0:MSYS_EI[0:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_CFG2_C0_0:UART_RX" "RX" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_CFG2_C0_0:UART_TX" "TX" }


# Add bus interface net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_CFG2_C0_0:APB_0_mINITIATOR" "MIV_RV32_CFG2_C0_0:APB_INITIATOR" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_RV32_CFG2_C0_0:AHBL_M_TARGET" "PF_SRAM_AHB_C0_0:AHBSlaveInterface" }

# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the SmartDesign 
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign "Basedesign"
generate_component -component_name ${sd_name}
