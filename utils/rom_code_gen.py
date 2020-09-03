#!/usr/bin/env python3

import getopt
import sys
import subprocess

def usage():
    print('This script reads a binary and generates verilog code for either a specific section or the whole file')
    print('You can also specifiy a hex file and leave the binary to generate verilog code for it')
    print('The verilog code is either printed out or put into an output file')
    print('\n!!!Do not use the rom RTL file as output, but a temporary file!!!\n')
    print('Usage:\n'+sys.argv[0]+' [-i  <hexfile>] [-o  <tmp_verilog_file>] [-s <startaddress>] [-l <addr_length>] [-h]')
    print('\t-i: binary to be transformed')
    print('\t-s: section to use (whole binary if not specified)')
    print('\t-h: hex file to use (can be used instead of binary)')
    print('\t-o: output verilog file (temporary). If not used, prints verilog to stdout')
    print('\t-a: start address where the code shall be placed in rom (default 0x20000000)')
    print('\t-l: address length of the rom (default 15 bits)')
    print('\t-w: rom data width in bits (default=32)')
    print('\t-h: this help')

def writeToFile(verFile, data):
  if(verFile == ''):
    print(data[:-1])
  else:
    vfile = open(verFile, 'a')
    vfile.write(data)

def hex2ver(hexFile, verFile, baseAddr, addrLen, dataWidth):
  NHex = dataWidth/4
  addr = baseAddr
  addrMask = (2**(addrLen+2))-1
  addr &= addrMask
  hfile = open(hexFile, 'r')
  verLine = ''
  verLineStart = str(addrLen) + '\'h'
  for line in hfile:
    line = line[:-1]
    lineRest = ''
    if(len(verLine) + len(line) > NHex):
      lineRest = line[:-(len(line)-NHex+len(verLine))]  
      line     = line[NHex-len(verLine):]
    verLine = line + verLine

    if(len(verLine) == NHex):
      writeToFile(verFile, verLineStart + hex(addr >> 3)[2:] + ': data <= '+ str(dataWidth) +'\'h' + verLine + ';\n')
      verLine = lineRest
      addr += 8
      addr &= addrMask

  if(len(verLine) != 0):
    for _ in range(NHex - len(verLine)):
      verLine = '0' + verLine
    writeToFile(verFile, verLineStart + hex(addr >> 3)[2:] + ': data <= '+ str(dataWidth) +'\'h' + verLine + ';\n')

def getHex(binary, hexFileTmp, section):
  cmd = 'riscv64-unknown-elf-objdump ' + binary + ' -d'
  proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
  hfile = open(hexFileTmp, 'w')

  stdout = str(proc.stdout.read())[2:-1]

  stdout = stdout.split('\\n')

  if(section != ''):
    section = section + ':'
    isSection = False
    for line in stdout:
      if(isSection):
        splits = line.split('\\t')
        if(len(splits) > 1):
          hfile.write(splits[1].replace(' ', '') + '\n')
        elif('section' in line):
          break
      else:
        if('section' in line and section in line):
          isSection = True
  else:
    for line in stdout:
      splits = line.split('\\t')
      if(len(splits) > 1):
        hfile.write(splits[1].replace(' ', '') + '\n')

  hfile.close()

def main():
  try:
    opts,_ = getopt.getopt(sys.argv[1:], "i:s:h:o:a:l:w:h")
  except getopt.GetoptError as err:
    # print help information and exit:
    print(str(err))
    usage()
    sys.exit(2)

  baseAddr = 0x20000000
  addrLen = 15
  verilogFile = ''
  hexFile = 'tmp.hex'
  binary = ''
  section = ''

  for o, a in opts:
    if o in ("-i"):
      binary = a
    elif o in ("-s"):
      section = a
    elif o in ("-h"):
      hexFile = a
    elif o in ("-o"):
      verilogFile = a
    elif o in ("-a"):
      baseAddr = int(a, 0)
    elif o in ("-l"):
      addrLen = int(a)
    elif o in ("-w"):
      dataWidth = int(a)
    elif o in ("-h"):
      usage()
      sys.exit()
    else:
      assert False, "unhandled option"

  if(binary != ''):
    getHex(binary=binary, hexFileTmp=hexFile, section=section)

  hex2ver(hexFile=hexFile, verFile=verilogFile, baseAddr=baseAddr, addrLen=addrLen, dataWidth=dataWidth)

if __name__ == "__main__":
    main()
