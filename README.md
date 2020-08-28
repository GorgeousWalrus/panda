# PandaZero
A RISC-V processor, destined to become a microcontroller!

Quick overview:
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
  * 1x UART

Improvement wishlist (in order of priority):
* Exception raising on illegal instruction
* JTAG tap for debug module
* Making debug module consistent with RV spec to use openOCD
* Improve critical path (caches)
* Extension to RV32F ISA (floating point)
* Simple out-of-order execution
* SPI APB slave
* I2C APB slave
* Switch to 64bit ISAs
