#!/bin/bash

# ----------------------------------------------------------------------------------------------------------------- 
# ===== CPU Benchmarks ============================================================================================
#   * Executables : cpu_intensive
#    -High-CPU requirements with no input and no output data. 
#     It imposes an amount of CPU stress on the system.
#   To deploy cpu benchmarks, run cpu_benchmarks command :
#
# ./cpu_benchmarks.sh -e Executable -c CPUNb -m MemorySize(Mbytes) -t timeout(sec) 
#
# where :
# Executable : cpu_intensive
# CPUNb : Number of CPU to use
# MemorySize : Amount of Memory to use in Mbytes
# timeout : time out after N seconds
#
# Example : cpu_benchmarks  -e cpu_intensive -c 3 -m 3000  -t 60 
#
#
#
#
#
#
#
#
#
#
#
#
#--------------------------------------------------------------------------------------------------------------------



# CPU intensive benchmark : 
# We ask for a virtual machine with 6 VCPU, 6000 Mbytes RAM.
# One the VM is running, set timeout to 1800 and  run cpu_intensive executable
# Get outputs in XML format
 
./cpu_benchmarks.sh -e cpu_intensive  -c 6 -m 6000 -t 300



