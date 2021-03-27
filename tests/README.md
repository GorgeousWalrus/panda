# Tests

## RTL Tests

The RTL test suite relies on verilator, which compiles the Verilog code and then runs a C++/SystemC based simulation.

You can run the tests by running `make` in the `rtl/` subdirectory.

In the `rtl/tests/` subdirectory, multiple simple tests are written, which are compiled, translated into hex and then pushed via UART into the simulation. The core then runs the program, which will finally write a result into a specific memory location (`0x10007ff0`).

The commonly expected result is a 1 within the address, which would correspond to a 0 being returned by the test.

The test `performance` is expected to result in the value of the timer and will therefore appear as `FAILED`. Here, simply take the number next to it as the amount of cycles the CPU required to complete the program, the test was successful.

## FPGA Tests

To do
