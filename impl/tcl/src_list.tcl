set RISCV_CORE " \
    $RTL/core/core_wrapper.sv \
    $RTL/core/core_top.sv \
    $RTL/core/registerFile.sv \
    $RTL/core/pipelineStages/execute/EX_stage.sv \
    $RTL/core/pipelineStages/execute/alu.sv \
    $RTL/core/pipelineStages/execute/executer.sv \
    $RTL/core/pipelineStages/instructionDecode/ID_stage.sv \
    $RTL/core/pipelineStages/instructionDecode/decoder.sv \
    $RTL/core/pipelineStages/instructionFetch/IF_stage.sv \
    $RTL/core/pipelineStages/instructionFetch/branch_predictor.sv \
    $RTL/core/pipelineStages/mem/MEM_stage.sv \
    $RTL/core/pipelineStages/mem/c_region_sel.sv \
    $RTL/core/pipelineStages/write_back/WB_stage.sv \
"

set MEMORY " \
    $RTL/memory/ram.sv \
    $RTL/memory/wb_ram_wrapper.sv \
"

set LSU " \
    $IPS/lsu/src/load_unit.sv \
    $IPS/lsu/src/store_unit.sv \
    $IPS/lsu/src/lsu.sv \
"

set CACHE " \
    $IPS/caches/src/cache.sv \
    $IPS/caches/src/cache_line.sv \
"

set WISHBONE " \
    $IPS/wishbone/src/wb_xbar.sv \
    $IPS/wishbone/src/wb_slave.sv \
    $IPS/wishbone/src/wb_master.sv \
"

set DBG_MODULE " \
    $IPS/debug_module/src/core_dbg_module.sv \
    $IPS/debug_module/src/dbg_module.sv \
"
set TIMER_MODULE " \
    $IPS/timer_module/src/timer.sv \
"
set GPIO_MODULE " \
    $IPS/gpio_module/src/gpio_module.sv \
"

set PANDA_WRAP " \
    $RTL/panda_wrapper.v
"