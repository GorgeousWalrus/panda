#!/usr/bin/env python3

import serial
import getopt
import sys
import time

class dbg_module():
  def __init__(self, tty, baudrate, timeout):
    self.uart = serial.Serial(
      port    = tty,
      baudrate= baudrate,
      parity  = serial.PARITY_ODD,
      stopbits= serial.STOPBITS_ONE,
      bytesize= serial.EIGHTBITS,
      timeout = timeout
    )

  def write(self, data):
    self.uart.write(data)
    ret = self.uart.read(size=4)
    if(ret != 0x1):
      return -1
    return 0

  def read(self):
    ret = self.uart.read(size=4)
    self.uart.write((0x1).to_bytes(4, 'little'))
    return int(ret)

  def write_mem(self, addr, data):
    self.write((0xc0).to_bytes(4, 'little'))
    self.write(addr.to_bytes(4, 'little'))
    self.write(data.to_bytes(4, 'little'))
    if(self.read() != 0x2):
      return -1
    return 0

  def read_mem(self, addr):
    self.write((0x80).to_bytes(4, 'little'))
    self.write(addr.to_bytes(4, 'little'))
    data = self.read()
    if(self.read() != 0x2):
      return -1
    return data

  def reset(self):
    self.write((0x1).to_bytes(4, 'little'))
    if(self.read() != 0x2):
      return -1
    return 0

  def halt(self):
    self.write((0x4).to_bytes(4, 'little'))
    if(self.read() != 0x2):
      return -1
    return 0

  def resume(self):
    self.write((0x5).to_bytes(4, 'little'))
    if(self.read() != 0x2):
      return -1
    return 0

  def set_pc(self, pc):
    self.write((0xc2).to_bytes(4, 'little'))
    self.write((0x0).to_bytes(4, 'little'))
    self.write((pc).to_bytes(4, 'little'))
  
  def load_binary(self, filename, startAddr):
    program = open(filename, 'r')
    for line in program:
      self.write((line).to_bytes(4, 'little'))

  def load_program(self, filename, startAddr):
    self.reset()
    self.halt()
    self.load_binary(filename, startAddr)
    self.set_pc(startAddr)
    self.resume()    

def main():
  try:
    opts,_ = getopt.getopt(sys.argv[1:], "i:s:h:o:a:l:h")
  except getopt.GetoptError as err:
    # print help information and exit:
    print(str(err))
    sys.exit(2)

  tty = '/dev/ttyUSB0'
  baudrate = 115200
  startAddr = 0x0

  for o, a in opts:
    if o in ("-i"):
      binary = a
    elif o in ("-a"):
      startAddr = int(a, 0)
    elif o in ("-t"):
      tty = a
    elif o in ("-b"):
      baudrate = int(a)
    else:
      assert False, "unhandled option"

  dbg_mod = dbg_module(tty, baudrate, 2)
  dbg_mod.load_program(binary, startAddr)

  for _ in range(60):
    time.sleep(1)
    ret = dbg_mod.read_mem(0x7ff0)
    if(ret != 0):
      print(ret)
      exit(0)


if __name__ == "__main__":
    main()
