# CLK
create_clock -period 20 -name sys_clk [get_nets -hierarchical -filter {NAME =~ clk}]

# PINS
