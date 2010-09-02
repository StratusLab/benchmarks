#!/bin/bash

# ----------------------------------------------------------------------------------------------------------------- 
# ===== OpenMP Benchmarks =====													
#  * Executables : openmp-cg, openmp-jacobi, openmp-matrix.
#    - openmp-cg implements conjugate gradient method, solving linear system Ax=b
#    - openmp-jacobi implements Jacobian type iteration solving linear system Ax=b
#    - openmp-matrix implements matrix multiplication C=AB
#
# For each executable, OpenMP Bemchmark run in both sequential and parallel mode.
#
# To deploy OpenMP benchmarks, run openmp_benchmarks command 
# Usage :
# openmp_benchmarks -e Executable -c CPUNb -m MemorySize(Mbytes) -n ThreadNb
# where :
# Executable : openmp-cg, openmp-jacobi or openmp-matrix
# CPUNb : Number of CPU to use
# MemorySize : Amount of Memory to use (Mbytes)
# ThreadNb : Number of thread to be used for OpenMP application
# Example : openmp_benchmarks -e openmp-cg  -c 3 -m 3000 -n 6
#
#
# This command generate Excecutable.xml  output file, in xml format, copied in the current directory. 
# This file contains informations :
# Benchmark, Application, Thread Number, CPU time and Elapsed for both parallel and sequential executables.
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
#
#--------------------------------------------------------------------------------------------------------------------



# OpenMP conjuguate gradient benchmark : 
# We ask for a virtual machine with 3 VCPU, 3000 Mbytes RAM.
# One the VM is running, set openmp threads to 5 and run openm-cg executable
# Get outputs in XML format
 
./openmp_benchmarks.sh -e openmp-cg  -c 3 -m 3000 -n 5

# OpenMP matrix multiplication benchmark : 
# We ask for a virtual machine with 4 VCPU, 4000 Mbytes RAM.
# One the VM is running, set openmp threads to 10 and run openm-matrix executable
# Get outputs in XML format



./openmp_benchmarks.sh -e openmp-matrix  -c 4 -m 4000 -n 10



# OpenMP matrix multiplication benchmark : 
# We ask for a virtual machine with 5 VCPU, 5000 Mbytes RAM.
# One the VM is running, set openmp threads to 15 and run openm-matrix executable
# Get outputs in XML format

./openmp_benchmarks.sh -e openmp-jacobi  -c 5 -m 5000 -n 15



