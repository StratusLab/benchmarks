#!/bin/bash

# ----------------------------------------------------------------------------------------------------------------- 
#   * Executable : kepler_install.sh kepler-nogui.sh
#
#          - kepler_install.sh : download, configure and install Kepler platform
#          - kepler-nogui.sh run kepler workflows
#
# To deploy kepler benchmarks, run kepler_benchmarks command :
#
# ./kepler_benchmarks.sh -e Executable -c CPUNb -m MemorySize(Mbytes) -w kepler_workflow 
#
#
# where :
# Executable : kepler-nogui
# CPUNb : Number of CPU to use
# MemorySize : Amount of Memory to use in Mbytes
# kepler_workflow : Kepler workflow in xml format
# Example : ./kepler_benchmarks.sh -e kepler-nogui -c 3 -m 3000  -w openmp.xml 
#
# This command generate Executable.xml output file, in xml format, copied in the current directory. 
# This file depends in the executables defined in the kepler_workflow.
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



# Kepler workflow benchmark : 
# We ask for a virtual machine with 5 VCPU, 5000 Mbytes RAM.
# we want to run matrix multiplication workflow.
# Once the VM is running, copy matrix_workflow.xml workflow file to the VM and  run kepler-nogui executable
# Get outputs in XML format
 
./kepler_benchmarks.sh -e kepler-nogui -c 5 -m 5000  -w ../scripts/workflows_bench/matrix_workflow.xml

