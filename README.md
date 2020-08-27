# PandaZero
A RISC-V processor, destined to become a microcontroller!

Quick overview:
* RV32I ISA
* 5 Stage Pipeline
* L1 instruction cache
* L1 data cache (write back)
* Simple branch predictor (predict backward branches as taken)
* Pipeline hazard detection & mitigation by HW via pipeline stalls
* Debug module
* Core connected to wishbone bus
* Bridge from wishbone to APB bus
* APB slaves:
  * 1x Timer
  * 8x GPIO

Upcoming features/improvements (in order of priority):
* APB uart slave
* Exception raising on illegal instruction
* Making debug module consistent with RV spec
* Extension to RV32F ISA (floating point)
