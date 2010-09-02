#!/bin/bash

function Usage()
{
echo "Usage : io_benchmarks.sh -e Executable -c CPUNb -m MemorySize(Mbytes) -i inputfile(Mbytes) -o outputfile(Mbytes)"

echo "where :

Executable : io-mpi-io
CPUNb : Number of CPU to use
MemorySize : Amount of Memory to use in Mbytes
Inputfile_size :  size of the input file in Mbytes
Outputfile_size :  size of the outputfile in Mbytes

Example : io_benchmarks -e io-mpi-io  -c 3 -m 3000  -i 100 -o 1000
"

exit -1
}



while getopts c:m:i:e:o: args
do
 case $args in
  m)
   MEMORY=$OPTARG
   ;;
  c)
   CPU=$OPTARG
   ;;
  i)
   INPUT_FILE=$OPTARG
   ;;
  o)
   OUTPUT_FILE=$OPTARG
   ;;
  e)
   Executable=$OPTARG
   ;;
  *) Usage
   ;;
 esac
done

[ -z "$INPUT_FILE" -o -z "$OUTPUT_FILE" -o -z "$Executable" -o -z "$CPU" -o -z "$MEMORY" ] && Usage

. bench_commons.sh


VM_NAME=io-$CPU
RESULTS=/home/oneadmin/results




# Create VM template

vm_template $VM_NAME $CPU $MEMORY

# Submit VM

vm_submit $VM_NAME

#Get IPADDRESS Of VM

ipaddress_vm $VM_NAME


echo "IPADDRESS=$IPADDRESS"

echo "Checking Virtual Machine Status"

check_vm_status $VM_NAME 600

if [ ${VM_STATUS[1]} != "RUNNING" ]; then
echo "Unable to start VM!"
exit -1
fi

echo "Checking Virtual Machine Network"

check_vm_network $IPADDRESS 300
if  [ $VM_CONNECTION_STATUS == "2" ]; then
echo "Unable to reach VM!"
exit -1
fi





#I/O Bench

#Benchmarks install from stratuslab yum repository

stratuslab_repo ${IPADDRESS} 

#Run benchmarks

echo "run $Executable  benchmark"

run_benchmarks $IPADDRESS $Executable $CPU $INPUT_FILE $OUTPUT_FILE

echo "retrieving $Executable  benchmark results"

#Get Outputs

get_output ${IPADDRESS} $Executable $RESULTS

#clean

clean $VM_NAME
