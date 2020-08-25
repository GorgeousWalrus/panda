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

logic [31:0]        ram_wb_data;  // data out
logic               ram_en;
logic               wb_ack_n, wb_ack_q;


assign wb_bus.wb_dat_sm = ram_wb_data;
assign wb_bus.wb_tgd_sm = 'b0;
assign wb_bus.wb_ack    = wb_ack_q;
assign wb_bus.wb_err    = 'b0;
assign wb_bus.wb_rty    = 'b0;

always_comb
begin
    wb_ack_n = 'b0;
    ram_en   = 1'b0;

    if(wb_bus.wb_cyc) begin
        ram_en   = 1'b1;
        if(!wb_ack_q)
            wb_ack_n = 1'b1;
    end
end

always_ff @(posedge clk, negedge rstn_i)
begin
    if(!rstn_i) begin
        wb_ack_q <= 1'b0;
    end else begin
        wb_ack_q <= wb_ack_n;
    end
end

ram #(
    .DEPTH      (DEPTH),
    .WORD_WIDTH (WORD_WIDTH)
)ram_i(
    .clk    ( clk              ),
    .rstn_i ( rstn_i           ),
    .addr_i ( wb_bus.wb_adr[$clog2(DEPTH)+1:2]),
    .en_i   ( ram_en           ),
    .we_i   ( wb_bus.wb_we     ),
    .din_i  ( wb_bus.wb_dat_ms ),
    .dout_o ( ram_wb_data      )
);


endmodule
/* verilator lint_on PINMISSING */