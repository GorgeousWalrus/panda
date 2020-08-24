PROJECT:=xilinx_clocking_wizard

default: all

all:
	vivado -mode batch -source tcl/run.tcl
	mkdir -p ip
	cp ${PROJECT}.srcs/sources_1/ip/${PROJECT}/${PROJECT}_stub.v ./ip
	cp ${PROJECT}.srcs/sources_1/ip/${PROJECT}/${PROJECT}.xci ./ip
	cp ${PROJECT}.srcs/sources_1/ip/${PROJECT}/${PROJECT}.veo ./ip
	cp ${PROJECT}.srcs/sources_1/ip/${PROJECT}/${PROJECT}.dcp ./ip

gui:
	vivado -mode gui -source tcl/run_native.tcl
	mkdir -p ip
	cp ${PROJECT}.srcs/sources_1/ip/${PROJECT}/${PROJECT}_stub.v ./ip
	cp ${PROJECT}.srcs/sources_1/ip/${PROJECT}/${PROJECT}.xci ./ip
	cp ${PROJECT}.srcs/sources_1/ip/${PROJECT}/${PROJECT}.veo ./ip
	cp ${PROJECT}.srcs/sources_1/ip/${PROJECT}/${PROJECT}.dcp ./ip

clean:
	rm -rf ip/*
	mkdir -p ip
	rm -rf ${PROJECT}.*
	rm -rf .Xil
	rm -rf component.xml
	rm -rf vivado*
	rm -rf xgui