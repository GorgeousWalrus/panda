default: rtltest

.PHONY: ips
ips: xilinx_clocking_wizard

xilinx_clocking_wizard:
	make -C ips/xilinx_clocking_wizard

.PHONY: impl
impl:
	make -C impl gui

.PHONY: rtltest
test:
	make -C tests/rtl all

clean:
	make -C impl clean
	make -C tests/rtl clean
	make -C ips/xilinx_clocking_wizard clean
