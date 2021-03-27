# PandaZero
A RISC-V processor, destined to become a microcontroller!

## Quick overview:
* RV32I ISA
* 5 Stage Pipeline
* L1 instruction cache
* L1 data cache (write back)
* Simple branch predictor (predict backward branches as taken)
* Pipeline hazard detection & mitigation by HW via pipeline stalls
* Debug module with UART tap (to be replaced with JTAG tap)
* Core connected to wishbone bus
* Bridge from wishbone to APB bus
* APB slaves:
  * 1x Timer
  * 8x GPIO
  * 1x UART incl. fifo

## Improvement wishlist (in order of priority):
* Exception raising on illegal instruction
* JTAG tap for debug module
* Making debug module consistent with RV spec to use openOCD
* Improve critical path (caches)
* Extension to RV32F ISA (floating point)
* Simple out-of-order execution
* SPI APB slave
* I2C APB slave
* Switch to 64bit ISAs

## Note

This is more a project to get experience in HW design than anything else. Therefore (so far) everything is 100% written by myself instead of using already existing implementations.

## How to use

### RTL Tests

To run the RTL test suite, you can simply run `make rtltest` here, or go into the `tests/rtl/` folder and run `make` there.

The RTL testsuite requires `verilator`.

For more information on the tests, please refer to the README.md in `tests/`.

### FPGA Implementation

Currently, the FPGA implementation is configured for the Xilinx Artix 7 A100TI FPGA (xc7a100ti-csg324-1L). It can be run by `make impl` here, which will start Vivado and run all the required steps to produce a bitstream (tested with Vivado 2020).

You can also run the implementation in batch mode by going into `impl/` and running `make` there.

The FPGA implementation of the core could not be completely verified, due to limited access to appropriate hardware.
