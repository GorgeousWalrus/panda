set partNumber xc7a100ti-csg324-1L

create_project xilinx_clocking_wizard . -part $partNumber -force

create_ip  -vlnv xilinx.com:ip:clk_wiz:6.0 -module_name xilinx_clocking_wizard

set_property -dict [list \
  CONFIG.PRIMITIVE {PLL} \
  CONFIG.CLKOUT1_DRIVES {BUFG} \
  CONFIG.CLKOUT2_DRIVES {BUFG} \
  CONFIG.CLKOUT3_DRIVES {BUFG} \
  CONFIG.CLKOUT4_DRIVES {BUFG} \
  CONFIG.CLKOUT5_DRIVES {BUFG} \
  CONFIG.CLKOUT6_DRIVES {BUFG} \
  CONFIG.CLKOUT7_DRIVES {BUFG} \
  CONFIG.MMCM_BANDWIDTH {OPTIMIZED} \
  CONFIG.MMCM_CLKFBOUT_MULT_F {9} \
  CONFIG.MMCM_COMPENSATION {ZHOLD} \
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {9} \
  CONFIG.CLKOUT1_JITTER {137.681} \
  CONFIG.CLKOUT1_PHASE_ERROR {105.461} \
  ] [get_ips xilinx_clocking_wizard]

generate_target all [get_files .xilinx_clocking_wizard.srcs/sources_1/ip/xilinx_clocking_wizard/xilinx_clocking_wizard.xci]
create_ip_run [get_files -of_objects [get_fileset sources_1] ./xilinx_clocking_wizard.srcs/sources_1/ip/xilinx_clocking_wizard/xilinx_clocking_wizard.xci]
launch_runs -jobs 8 xilinx_clocking_wizard_synth_1
wait_on_run xilinx_clocking_wizard_synth_1