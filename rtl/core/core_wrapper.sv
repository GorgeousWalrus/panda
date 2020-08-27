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
// Module name: core_wrapper
// 
// Functionality: Verilog wrapper file for the core, in order
//                to instantiate it in a block design in Vivado
//                and connect a BRAM
//
// ------------------------------------------------------------

/* verilator lint_off PINMISSING */

`include "dbg_intf.sv"
`include "wb_intf.sv"

module core_wrapper
(
    input wire          sys_clk_i,
    input wire          rstn_i,
    // GPIO
    output wire [7:0]   gpio_dir_o,
    output wire [7:0]   gpio_val_o,
    input wire [7:0]    gpio_val_i,
    // Debug interface
    input wire [7:0]    dbg_cmd_i,
    input wire [31:0]   dbg_addr_i,
    input wire [31:0]   dbg_data_i,
    output wire [31:0]  dbg_data_o,
    output wire         dbg_ready_o
);

// Reset signals
logic core_rst_reqn;
logic core_rst_req;
logic periph_rst_req;

// interrupts
logic [1:0]   timer_irqs;
logic [7:0]   gpio_irqs;

// debug signals
logic dbg_core_rst_req;
logic dbg_periph_rst_req;

// Wishbone busses
wb_bus_t#(.TAGSIZE(1)) masters[3:0]();
wb_bus_t#(.TAGSIZE(1)) slaves[3:0]();

// Debug bus
dbg_intf dbg_bus();

// Reset requests
// TODO This is faulty!
assign core_rst_req   = ((~dbg_core_rst_req) & rstn_i);
assign periph_rst_req = (~dbg_periph_rst_req) & rstn_i;

core_top #(
    // instruction cache
    .ICACHE_NLINES  ( 8 ),
    .ICACHE_WoPerLi ( 8  ),
    // data cache
    .DCACHE_NLINES  ( 16 ),
    .DCACHE_WoPerLi ( 8  ),
    // Cacheable regions
    .N_C_REGIONS    ( 2  ),
    .C_REGION_START ( {32'h00000000, 32'h10000000} ),
    .C_REGION_END   ( {32'h00004000, 32'h10007000} )
) core_i (
    .clk            ( sys_clk_i     ),
    .rstn_i         ( core_rst_req  ),
    .rst_reqn_o     ( core_rst_reqn ),
    .IF_wb_bus      ( masters[3]    ),
    .MEM_wb_bus_c   ( masters[2]    ),
    .MEM_wb_bus_lsu ( masters[1]    ),
    .dbg_bus        ( dbg_bus       )
);

dbg_module dbg_module_i (
  .clk              ( sys_clk_i         ),
  .rstn_i           ( rstn_i            ),
  .cmd_i            ( dbg_cmd_i         ),
  .addr_i           ( dbg_addr_i        ),
  .data_i           ( dbg_data_i        ),
  .data_o           ( dbg_data_o        ),
  .ready_o          ( dbg_ready_o       ),
  .core_rst_req_o   ( dbg_core_rst_req  ),
  .periph_rst_req_o ( dbg_periph_rst_req),
  .dbg_bus          ( dbg_bus           ),
  .wb_bus           ( masters[0]        )
);

// Not really a rom, just the name so far...
wb_ram_wrapper #(
  .DEPTH (16384)
) rom_i (
  .clk    ( sys_clk_i ),
  .rstn_i ( rstn_i    ),
  .wb_bus ( slaves[0] )
);

wb_ram_wrapper #(
  .DEPTH (32768)
) ram_i (
  .clk    ( sys_clk_i ),
  .rstn_i ( rstn_i    ),
  .wb_bus ( slaves[1] )
);

wb_xbar #(
    .TAGSIZE        ( 1 ),
    .N_SLAVE        ( 4 ),
    .N_MASTER       ( 4 )
) wb_xbar_i (
    .clk_i          ( sys_clk_i ),
    .rst_i          ( ~rstn_i   ),
    .wb_slave_port  (masters    ),
    .wb_master_port (slaves     )
);

timer timer_i(
  .clk      ( sys_clk_i      ),
  .rstn_i   ( periph_rst_req ),
  .irq_o    ( timer_irqs     ),
  .wb_bus   ( slaves[2]      )
);

gpio_module #(
  .N_GPIOS ( 8 )
) gpio_i (
  .clk      ( sys_clk_i   ),
  .rstn_i   ( rstn_i      ),
  .dir_o    ( gpio_dir_o  ),
  .val_o    ( gpio_val_o  ),
  .val_i    ( gpio_val_i  ),
  .irq_o    ( gpio_irqs   ),
  .wb_bus   ( slaves[3]   )
);

endmodule