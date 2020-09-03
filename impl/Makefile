default: batch

batch: cleanall
	vivado -mode batch -source tcl/run.tcl &

gui: cleanall
	vivado -mode gui -source tcl/run.tcl &

cleanall: clean
	rm -rf *.hw
	rm -rf *.runs
	rm -rf *.sim
	rm -rf *.srcs
	rm -rf *.xpr
	rm -rf *.prm
	rm -rf *.mcs
	
clean:
	rm -rf vivado*
	rm -rf .Xil
	rm -rf *.cache
	rm -rf *.hbs
	rm -rf *.ip_user_files
