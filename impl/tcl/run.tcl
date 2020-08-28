set NAME "panda"

create_project ${NAME} . -force -part xc7a100ti-csg324-1L

set RTL ../rtl
set IPS ../ips

source tcl/inc_dirs.tcl
source tcl/src_list.tcl
source tcl/src_add.tcl

add_files -norecurse $IPS/xilinx_clocking_wizard/ip/xilinx_clocking_wizard.xci

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

set_property top ${NAME}_wrapper [current_fileset]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

add_files -fileset constrs_1 -norecurse constraints/constraints.xdc

reset_run synth_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1

# launch_runs impl_1 -to_step write_bitstream -jobs 7
# wait_on_run impl_1
