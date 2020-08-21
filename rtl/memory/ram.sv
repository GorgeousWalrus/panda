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
// Module name: ram
// 
// Functionality: Single port ram
//
// ------------------------------------------------------------

module ram #(
    parameter SIZE = 1024
)(
    input logic           clk,
    input logic           rstn_i,
    input logic [31:0]    addr_i,
    input logic           en_i,
    input logic [3:0]     we_i,
    input logic [31:0]    din_i,
    output logic [31:0]   dout_o
);


(*ram_style = "block" *) reg [31:0] data[0:SIZE-1];

always_ff @(posedge clk, negedge rstn_i)
begin
    if(!rstn_i) begin
    end else begin
        dout_o <= data[addr_i[31:2]];
        if(en_i && we_i[0])
            data[addr_i[31:2]] <= din_i;
    end
end

endmodule