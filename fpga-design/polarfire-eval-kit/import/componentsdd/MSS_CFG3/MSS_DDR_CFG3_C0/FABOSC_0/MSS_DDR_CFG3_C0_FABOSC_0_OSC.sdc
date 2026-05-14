set_component MSS_DDR_CFG3_C0_FABOSC_0_OSC
# Microchip Technology Inc.
# Date: 2026-May-07 23:20:20
#

create_clock -ignore_errors -period 20 [ get_pins { I_RCOSC_25_50MHZ/CLKOUT } ]
