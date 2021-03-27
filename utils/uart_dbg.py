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
      parity  = serial.PARITY_NONE,
      stopbits= serial.STOPBITS_ONE,
      bytesize= serial.EIGHTBITS,
      timeout = timeout
    )

  def write_mem(self, addr, data):
    self.uart.write(0xc0.to_bytes(1,'little'))
    self.uart.write(addr.to_bytes(4,'little'))
    self.uart.write(data.to_bytes(4,'little'))
    ack = self.uart.read(1)
    while(ack == b''):
      ack = self.uart.read(1)
    if(ack != b'\xaa'):
      return -1
    return 0

  def read_mem(self, addr):
    self.uart.write(0x80.to_bytes(1,'little'))
    self.uart.write(addr.to_bytes(4,'little'))
    ret = self.uart.read(size=4)
    ack = self.uart.read(1)
    while(ack == b''):
      ack = self.uart.read(1)
    if(ack != b'\xaa'):
      return -1  
    return ret

  def reset(self):
    self.uart.write((0x1).to_bytes(1, 'little'))
    ack = self.uart.read(1)
    while(ack == b''):
      ack = self.uart.read(1)
    if(ack != b'\xaa'):
      return -1
    return 0

  def halt(self):
    self.uart.write((0x4).to_bytes(1, 'little'))
    ack = self.uart.read(1)
    while(ack == b''):
      ack = self.uart.read(1)
    if(ack != b'\xaa'):
      return -1
    return 0

  def resume(self):
    self.uart.write((0x5).to_bytes(1, 'little'))
    ack = self.uart.read(1)
    while(ack == b''):
      ack = self.uart.read(1)
    if(ack != b'\xaa'):
      return -1
    return 0

  def set_pc(self, pc):
    self.uart.write((0xc2).to_bytes(1, 'little'))
    self.uart.write((0x0).to_bytes(4, 'little'))
    self.uart.write((pc).to_bytes(4, 'little'))
    ack = self.uart.read(1)
    while(ack == b''):
      ack = self.uart.read(1)
    if(ack != b'\xaa'):
      return -1
    return 0
  
  def get_pc(self):
    self.uart.write((0x82).to_bytes(1, 'little'))
    self.uart.write((0x0).to_bytes(4, 'little'))
    ret = self.uart.read(size=4)
    ack = self.uart.read(1)
    while(ack == b''):
      ack = self.uart.read(1)
    if(ack != b'\xaa'):
      return -1  
    return ret

  def load_binary(self, filename, startAddr):
    program = open(filename, 'r')
    i = startAddr
    for line in program:
      self.write_mem(i, int(line,16))
      i += 4
    program.close()
    program = open(filename, 'r')
    i = startAddr
    for line in program:
      if(self.read_mem(i) != int(line,16).to_bytes(4,'little')):
        return (i-startAddr)/4+1
      i += 4
    return 0


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
