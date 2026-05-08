set_component MSS_CFG3_C0
# Microchip Technology Inc.
# Date: 2026-May-07 23:19:03
#

create_clock -period 80 [ get_pins { MSS_ADLIB_INST/CLK_CONFIG_APB } ]
set_false_path -ignore_errors -through [ get_pins { MSS_ADLIB_INST/CONFIG_PRESET_N } ]
