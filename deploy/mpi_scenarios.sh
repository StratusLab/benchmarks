#!/bin/bash

# ------------------------------------------------------------------------------------------------------------------ 
#===== MPI Benchmarks ==============================================================================================
#
#  *Executables : mpi-async, mpi-sync, mpi-persistent, mpi-standard.
#    -mpi-async implements MPI asynchronous non blocking communication
#    -mpi-sync implements MPI synchronous blocking communication
#    -mpi-persistent implements MPI persistent communication
#    -mpi-standard implements MPI standard communication.
#
# These executables links with lapack library for LU factorization.
#
#
#
# To deploy MPI benchmarks, run mpi_benchmarks command :
# mpi_benchmarks -e Executable -c CPUNb -m MemorySize(Mbytes) 
# 
# where :
#
# Executable : mpi-async, mpi-sync, mpi-persistent or mpi-standard.
# CPUNb : Number of CPU to use
# MemorySize : Amount of Memory to use (Mbytes)
# Example : mpi_benchmarks -e mpi-sync  -c 3 -m 3000 
#
# 
#
#
#
#
# This command generate Excecutable.xml  output file, in xml format, copied in the current directory. 
# This file contains informations :
# Benchmark, Application, CPU time and Elapsed time.
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



# MPI synchronous communication benchmark : 
# We ask for a virtual machines cluster  with 10 VCPU, 10000 MBytes RAM.
# Once the VMs are running, copy hostfile to the frontend and run mpi-sync executable
# Get outputs in XML format
 
./mpi_benchmarks.sh -e mpi-sync  -c 10 -m 10000 

# MPI standard communication benchmark : 
# We ask for a virtual machines cluster  with 18 VCPU, 18000 MBytes RAM.
# Once the VMs are running, copy hostfile to the frontend and run mpi-sync executable
# Get outputs in XML format


./mpi_benchmarks.sh -e mpi-standard  -c 18 -m 18000



