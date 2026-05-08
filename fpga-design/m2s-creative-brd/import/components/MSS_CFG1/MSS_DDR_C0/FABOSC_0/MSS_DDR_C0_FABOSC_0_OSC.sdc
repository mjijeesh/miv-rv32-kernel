set_component MSS_DDR_C0_FABOSC_0_OSC
# Microchip Technology Inc.
# Date: 2026-Apr-27 12:45:32
#

create_clock -ignore_errors -period 20 [ get_pins { I_RCOSC_25_50MHZ/CLKOUT } ]
