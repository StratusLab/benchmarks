#!/bin/bash

function Usage()
{
echo "Usage : openmp_benchmarks.sh -e Executable -c CPUNb -m MemorySize(Mbytes) -n ThreadNb"

echo "where :

Executable : openmp-cg, openmp-jacobi or openmp-matrix
CPUNb : Number of CPU to use
MemorySize : Amount of Memory to use (Mbytes)
ThreadNb : Number of thread to be used for OpenMP application

Example : openmp_benchmarks -e openmp-cg -c 3 -m 3000 -n 6
"

exit -1
}



while getopts c:m:n:e: args
do
 case $args in
  m)
   MEMORY=$OPTARG
   ;;
  c)
   CPU=$OPTARG
   ;;
  n)
   ThreadNb=$OPTARG
   ;;
  e)
   Executable=$OPTARG
   ;;
  *) Usage
   ;;
 esac
done

[ -z "$ThreadNb" -o -z "$Executable" -o -z "$CPU" -o -z "$MEMORY" ] && Usage



. bench_commons.sh

logfile $Executable $PWD


VM_NAME=openmp$CPU
RESULTS=$PWD/Outputs/$Executable-$$


# Create VM template

vm_template $VM_NAME $CPU $MEMORY

# Submit VM

vm_submit $VM_NAME

#Get IPADDRESS Of VM

ipaddress_vm $VM_NAME

echo "IPADDRESS=$IPADDRESS"


#Check Virtual Machine Status

echo "Checking Virtual Machine Status"

check_vm_status $VM_NAME 600
if [ ${VM_STATUS[1]} != "RUNNING" ]; then
echo "Unable to start VM!"
exit -1
fi

#Check Virtual Machine Network

echo "Checking Virtual Machine Network"

check_vm_network $IPADDRESS 300

if  [ $VM_CONNECTION_STATUS == "2" ]; then
echo "Unable to reach VM!"
exit -1
fi

#OpenMP Matrix
#Benchmarks install from stratuslab yum repository

stratuslab_repo ${IPADDRESS} 

#Run benchmarks

echo "run $Executable  benchmark"

run_benchmarks $IPADDRESS $Executable $ThreadNb


#Get Outputs 
echo "retrieving $Executable  benchmark results"

get_output ${IPADDRESS} $Executable $RESULTS

#clean

clean $VM_NAME


