module panda_wrapper (
  input wire              clk,
  input wire              rstn_i,
  // DEBUG
  input wire [7:0]        dbg_cmd_i,
  input wire [31:0]       dbg_addr_i,
  input wire [31:0]       dbg_data_i,
  output wire [31:0]      dbg_data_o,
  output wire             dbg_ready_o,
  // GPIO
  inout wire [7:0]        gpio_io
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

core_wrapper core_i(
  .clk         ( clk         ),
  .rstn_i      ( rstn_i      ),
  .gpio_dir_o  ( gpio_dir    ),
  .gpio_val_i  ( gpio_val_i  ),
  .gpio_val_o  ( gpio_val_o  ),
  .dbg_cmd_i   ( dbg_cmd_i   ),
  .dbg_addr_i  ( dbg_addr_i  ),
  .dbg_data_i  ( dbg_data_i  ),
  .dbg_data_o  ( dbg_data_o  ),
  .dbg_ready_o ( dbg_ready_o )
);

endmodule