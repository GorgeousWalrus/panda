# -------------------------------------
# CLK
# -------------------------------------

# ext_clk_i and sys_clk are defined in clocking_wizard constraints

# -------------------------------------
# PINS
# -------------------------------------

# Clock
set_property PACKAGE_PIN F4 [get_ports ext_clk_i]
set_property IOSTANDARD SSTL15 [get_ports ext_clk_i]

# Reset
set_property PACKAGE_PIN D14 [get_ports ext_rstn_i]
set_property IOSTANDARD LVCMOS33 [get_ports ext_rstn_i]
set_property PULLUP true [get_ports ext_rstn_i]

# LED
set_property PACKAGE_PIN L15 [get_ports led_o]
set_property IOSTANDARD LVCMOS33 [get_ports led_o]

# UART
set_property PACKAGE_PIN A10 [get_ports uart_tx_o]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx_o]
set_property PACKAGE_PIN A11 [get_ports uart_rx_i]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rx_i]

# Debug UART
set_property PACKAGE_PIN D12 [get_ports dbg_uart_tx_o]
set_property IOSTANDARD LVCMOS33 [get_ports dbg_uart_tx_o]
set_property PACKAGE_PIN D13 [get_ports dbg_uart_rx_i]
set_property IOSTANDARD LVCMOS33 [get_ports dbg_uart_rx_i]
