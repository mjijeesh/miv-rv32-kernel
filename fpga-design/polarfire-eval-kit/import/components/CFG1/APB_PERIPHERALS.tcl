# Creating SmartDesign "APB_PERIPHERALS"
set sd_name {APB_PERIPHERALS}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {APB3mmaster_PENABLE} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {APB3mmaster_PSEL} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {APB3mmaster_PWRITE} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PCLK} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PRESETn} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RX} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SPISDI} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SW1} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SW2} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {APB3mmaster_PREADY} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {APB3mmaster_PSLVERR} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED1} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED2} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED3} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED4} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SPISCLKO} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SPISDO} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SPISS} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TIMINT_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TIMINT_1} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TX} -port_direction {OUT}


# Create top level Bus Ports
sd_create_bus_port -sd_name ${sd_name} -port_name {APB3mmaster_PADDR} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {APB3mmaster_PWDATA} -port_direction {IN} -port_range {[31:0]}

sd_create_bus_port -sd_name ${sd_name} -port_name {APB3mmaster_PRDATA} -port_direction {OUT} -port_range {[31:0]}


# Create top level Bus interface Ports
sd_create_bif_port -sd_name ${sd_name} -port_name {APB3mmaster} -port_bif_vlnv {AMBA:AMBA2:APB:r0p0} -port_bif_role {mirroredMaster} -port_bif_mapping {\
"PADDR:APB3mmaster_PADDR" \
"PSELx:APB3mmaster_PSEL" \
"PENABLE:APB3mmaster_PENABLE" \
"PWRITE:APB3mmaster_PWRITE" \
"PRDATA:APB3mmaster_PRDATA" \
"PWDATA:APB3mmaster_PWDATA" \
"PREADY:APB3mmaster_PREADY" \
"PSLVERR:APB3mmaster_PSLVERR" } 

# Add CoreAPB3_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CoreAPB3_C0} -instance_name {CoreAPB3_C0_0}



# Add CoreGPIO_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CoreGPIO_C0} -instance_name {CoreGPIO_C0_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_C0_0:GPIO_OUT} -pin_slices {[0:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_C0_0:GPIO_OUT} -pin_slices {[1:1]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_C0_0:GPIO_OUT} -pin_slices {[2:2]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_C0_0:GPIO_OUT} -pin_slices {[3:3]}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreGPIO_C0_0:INT}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CoreGPIO_C0_0:GPIO_IN} -value {GND}



# Add CoreGPIO_C1_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CoreGPIO_C1} -instance_name {CoreGPIO_C1_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_C1_0:GPIO_IN} -pin_slices {[0:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_C1_0:GPIO_IN} -pin_slices {[1:1]}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreGPIO_C1_0:INT}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreGPIO_C1_0:GPIO_OUT}



# Add CORESPI_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CORESPI_C0} -instance_name {CORESPI_C0_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CORESPI_C0_0:SPISS} -pin_slices {[0:0]}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORESPI_C0_0:SPIINT}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORESPI_C0_0:SPIRXAVAIL}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORESPI_C0_0:SPITXRFM}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORESPI_C0_0:SPISSI} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORESPI_C0_0:SPICLKI} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORESPI_C0_0:SPIOEN}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORESPI_C0_0:SPIMODE}



# Add CoreTimer_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CoreTimer_C0} -instance_name {CoreTimer_C0_0}



# Add CoreTimer_C1_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CoreTimer_C1} -instance_name {CoreTimer_C1_0}



# Add CoreUARTapb_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CoreUARTapb_C0} -instance_name {CoreUARTapb_C0_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreUARTapb_C0_0:TXRDY}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreUARTapb_C0_0:RXRDY}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreUARTapb_C0_0:PARITY_ERR}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreUARTapb_C0_0:OVERFLOW}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreUARTapb_C0_0:FRAMING_ERR}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORESPI_C0_0:PCLK" "CoreGPIO_C0_0:PCLK" "CoreGPIO_C1_0:PCLK" "CoreTimer_C0_0:PCLK" "CoreTimer_C1_0:PCLK" "CoreUARTapb_C0_0:PCLK" "PCLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORESPI_C0_0:PRESETN" "CoreGPIO_C0_0:PRESETN" "CoreGPIO_C1_0:PRESETN" "CoreTimer_C0_0:PRESETn" "CoreTimer_C1_0:PRESETn" "CoreUARTapb_C0_0:PRESETN" "PRESETn" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORESPI_C0_0:SPISCLKO" "SPISCLKO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORESPI_C0_0:SPISDI" "SPISDI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORESPI_C0_0:SPISDO" "SPISDO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORESPI_C0_0:SPISS[0:0]" "SPISS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreGPIO_C0_0:GPIO_OUT[0:0]" "LED1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreGPIO_C0_0:GPIO_OUT[1:1]" "LED2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreGPIO_C0_0:GPIO_OUT[2:2]" "LED3" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreGPIO_C0_0:GPIO_OUT[3:3]" "LED4" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreGPIO_C1_0:GPIO_IN[0:0]" "SW1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreGPIO_C1_0:GPIO_IN[1:1]" "SW2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreTimer_C0_0:TIMINT" "TIMINT_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreTimer_C1_0:TIMINT" "TIMINT_1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreUARTapb_C0_0:RX" "RX" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreUARTapb_C0_0:TX" "TX" }


# Add bus interface net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB3mmaster" "CoreAPB3_C0_0:APB3mmaster" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORESPI_C0_0:APB_bif" "CoreAPB3_C0_0:APBmslave6" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreAPB3_C0_0:APBmslave1" "CoreUARTapb_C0_0:APB_bif" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreAPB3_C0_0:APBmslave2" "CoreGPIO_C1_0:APB_bif" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreAPB3_C0_0:APBmslave3" "CoreTimer_C0_0:APBslave" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreAPB3_C0_0:APBmslave4" "CoreTimer_C1_0:APBslave" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreAPB3_C0_0:APBmslave5" "CoreGPIO_C0_0:APB_bif" }

# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the SmartDesign 
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign "APB_PERIPHERALS"
generate_component -component_name ${sd_name}
