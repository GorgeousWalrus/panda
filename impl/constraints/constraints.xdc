# CLK
create_clock -period 10 -name sys_clk [get_nets -hierarchical -filter {NAME =~ clk}]

# PINS
