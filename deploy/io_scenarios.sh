#!/bin/bash

# ------------------------------------------------------------------------------------------------------------------------ 
# ===== I/O Benchmarks =====
#  * Executables : io_mpi_io.
#    - io_mpi_io, read from a file and write to another. It immplements MPI I/O methods. 
#  It could be used with small input data/large output data, small input data/ small output data, 
#  large input data/small output data or large input data/ large output data. 
#
# To deploy I/O benchmarks, run io_benchmarks command :
#
# ./io_benchmarks.sh -e Executable -c CPUNb -m MemorySize(Mbytes) -i Inputfile_size(Mbytes) -o Outputfile_size(Mbytes) 
# where :
# Executable : io-mpi-io
# CPUNb : Number of CPU to use
# MemorySize : Amount of Memory to use in Mbytes
# Inputfile_size : size of the input file in Mbytes
# Outputfile_size : size of the output file in Mbytes
# Example : io_benchmarks -e io-mpi-io  -c 3 -m 3000  -i 100 -o 1000 
#
# This command generate Excecutable.xml  output file, in xml format, copied in the current directory. 
# This file contains informations :
# Benchmark, Application, inputfile, size of the inputfile, outputfile, size of the outputfile,  CPU time and Elapsed time.
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
#----------------------------------------------------------------------------------------------------------------------



# I/O MPI  benchmark : 
# We ask for a virtual machines  with 5 VCPU, 10000 MBytes RAM.
# We want to run I/O benchmark with Inputfile_size = 10 Mbytes, Outputfile_size = 2000 Mbytes
# Once the VM are running, we generate the inputfile and run io_mpi_io executable
# Get outputs in XML format
 
./io_benchmarks.sh -e io_mpi_io  -c 5 -m 10000 -i 10 -o 2000

# I/O MPI  benchmark : 
# We ask for a virtual machines  with 5 VCPU, 10000 MBytes RAM.
# We want to run I/O benchmark with Inputfile_size = 2000 Mbytes, Outputfile_size = 2000 Mbytes
# Once the VM are running, we generate the inputfile and run io_mpi_io executable
# Get outputs in XML format

./io_benchmarks.sh -e io_mpi_io  -c 5 -m 10000 -i 2000 -o 2000




# I/O MPI  benchmark : 
# We ask for a virtual machines  with 5 VCPU, 10000 MBytes RAM.
# We want to run I/O benchmark with Inputfile_size = 2000 Mbytes, Outputfile_size = 10 Mbytes
# Once the VM are running, we generate the inputfile and run io_mpi_io executable
# Get outputs in XML format

./io_benchmarks.sh -e io_mpi_io  -c 5 -m 10000 -i 2000 -o 10
 




