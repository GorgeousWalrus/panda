module panda_wrapper (
  input wire              ext_clk_i,
  input wire              ext_rst_i,
  // DEBUG
  input wire              dbg_uart_rx_i,
  output wire             dbg_uart_tx_o,
  // GPIO
  inout wire [7:0]        gpio_io,
  // UART
  input wire              uart_rx_i,
  output wire             uart_tx_o
);

wire [7:0] gpio_val_i;
wire [7:0] gpio_val_o;
wire [7:0] gpio_dir;

for(genvar ii = 0; ii < 8; ii = ii + 1) begin : GPIO_IO_BUF
  IOBUF iobuf_gpio(
    .I  ( gpio_val_o[ii]  ),
    .O  ( gpio_val_i[ii]  ),
    .IO ( gpio_io[ii]     ),
    .T  ( gpio_dir[ii]    )
  );
end

xilinx_clocking_wizard clk_gen_i(
  .clk_in1    ( ext_clk_i   ),
  .reset      ( ext_rst_i   ),
  .locked     ( po_rstn     ),
  .clk_out1   ( sys_clk     )
);

core_wrapper core_i(
  .sys_clk_i      ( sys_clk       ),
  .rstn_i         ( po_rstn       ),
  .gpio_dir_o     ( gpio_dir      ),
  .gpio_val_i     ( gpio_val_i    ),
  .gpio_val_o     ( gpio_val_o    ),
  .dbg_uart_rx_i  ( dbg_uart_rx_i ),
  .dbg_uart_tx_o  ( dbg_uart_tx_o ),
  .uart_rx_i      ( uart_rx_i     ),
  .uart_tx_o      ( uart_tx_o     )
);

endmodule