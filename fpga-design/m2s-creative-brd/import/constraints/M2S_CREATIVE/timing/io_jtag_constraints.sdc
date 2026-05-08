create_clock -name { TCK } \
-period 166.67 \
-waveform { 0 83.33 } \
[ get_ports { TCK } ]


create_clock -name { REF_CLK } \
-period 20.0 \
-waveform { 0 10 } \
[ get_ports { REF_CLK } ]

# JTAG and Mi-V clocks are independent - adding asynchronous clock group
set_clock_groups -name {async1} -asynchronous -group [ get_clocks { REF_CLK } ] -group [ get_clocks { TCK } ]
