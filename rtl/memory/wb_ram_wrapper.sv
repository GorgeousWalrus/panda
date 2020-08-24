// ------------------------ Disclaimer -----------------------
// No warranty of correctness, synthesizability or 
// functionality of this code is given.
// Use this code under your own risk.
// When using this code, copy this disclaimer at the top of 
// Your file
//
// (c) Luca Hanel 2020
//
// ------------------------------------------------------------
//
// Module name: wb_ram_wrapper.sv
// 
// Functionality: Simple wrapper for the ram and wishbone slave
//                interface
//
// ------------------------------------------------------------

/* verilator lint_off PINMISSING */
module wb_ram_wrapper #(
    parameter DEPTH = 1024,
    parameter WORD_WIDTH = 32,
    parameter ADDR_WIDTH = 32
)(
    input logic             clk,
    input logic             rstn_i,
    wb_bus_t.slave          wb_bus
);

logic [WORD_WIDTH-1:0]  ram_wb_d;
logic [WORD_WIDTH-1:0]  wb_ram_d;
logic [ADDR_WIDTH-1:0]  addr;
logic                   wb_we;
logic [3:0]             wb_sel;
logic                   ram_we;

assign ram_we = wb_we;

wb_slave #(
    .TAGSIZE    ( 1         )
)wb_slave_i(
    .clk_i      ( clk       ),
    .rst_i      ( ~rstn_i   ),
    .data_i     ( ram_wb_d  ),
    .data_o     ( wb_ram_d  ),
    .addr_o     ( addr      ),
    .we_o       ( wb_we     ),
    .sel_o      ( wb_sel    ),
    .valid_i    ( 1'b1      ),
    .wb_bus     ( wb_bus    )
);

ram #(
    .DEPTH      (DEPTH),
    .WORD_WIDTH (WORD_WIDTH)
)ram_i(
    .clk    ( clk       ),
    .rstn_i ( rstn_i    ),
    /* verilator lint_off WIDTH */
    .addr_i ( addr[$clog2(DEPTH)+1:2]),
    /* verilator lint_on WIDTH */
    .en_i   ( 1'b1      ),
    .we_i   ( ram_we    ),
    .din_i  ( wb_ram_d  ),
    .dout_o ( ram_wb_d  )
);

endmodule
/* verilator lint_on PINMISSING */