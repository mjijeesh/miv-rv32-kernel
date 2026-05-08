set_component MSS_DDR_CFG2_C0_CCC_0_FCCC
# Microchip Technology Inc.
# Date: 2026-May-08 11:54:29
#

create_clock -period 20 [ get_pins { CCC_INST/CLK0 } ]
create_generated_clock -multiply_by 2 -divide_by 2 -source [ get_pins { CCC_INST/CLK0 } ] -phase 0 [ get_pins { CCC_INST/GL2 } ]
