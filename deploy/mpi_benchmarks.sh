#!/bin/bash
function Usage()
{
echo "Usage : mpi_benchmarks.sh -e Executable -c CPUNb -m MemorySize(Mbytes)"

echo "where :

Executable : mpi-async, mpi-sync, mpi-persistent or mpi-standard.
CPUNb : Number of CPU to use
MemorySize : Amount of Memory to use (Mbytes)

Example : mpi_benchmarks -e mpi-sync  -c 3 -m 3000
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
  e)
   Executable=$OPTARG
   ;;
  *) Usage
   ;;
 esac
done

[ -z "$Executable" -o -z "$CPU" -o -z "$MEMORY" ] && Usage

. bench_mpi_inc.sh

logfile $Executable $PWD


BENCHMARK_NAME=$Executable
VM_NAME=mpi$CPU
RESULTS=$PWD/Outputs/$Executable-$$

echo "MEMORY=$MEMORY"
echo "CPU=$CPU"
echo "Executable=$Executable"









IP_ARRAY=();
VMNAME_ARRAY=();





#Check available cpu

available_cpu

#Check acailable memory

available_memory

#Memory per CPU

let "MEMCPU = $MEMORY/$CPU"

#Submit mpi cluster

submit_mpi_cluster $CPU $MEMCPU


echo "Adresses IP : ${IP_ARRAY[*]}"
echo "VM Names : ${VMNAME_ARRAY[*]}"

#Check status of VMs

for j in "${VMNAME_ARRAY[@]}"; do
echo "Checking  $j Virtual Machine Status" 
check_vm_status $j 600
if [ ${VM_STATUS[1]} != "RUNNING" ]; then
echo "Unable to start $j VM!"
exit -1
fi
done

#Check network of VMs

for j in "${IP_ARRAY[@]}"; do
echo "Checking  $j Virtual Machine Network" 
check_vm_network $j 300
if  [ "$VM_CONNECTION_STATUS" == "2" ]; then
echo "Unable to reach $j VM!"
exit -1
fi
done





#FRONTEND_INDEX=`echo ${!IP_ARRAY[*]} | cut -f1 -d" "`
#echo "FRONTEND_INDEX=$FRONTEND_INDEX"
let "FRONTEND_INDEX = 0"
#mpicluster

mpi_sshkey_gen ${IP_ARRAY[$FRONTEND_INDEX]} 

copy_file ${IP_ARRAY[$FRONTEND_INDEX]} hostfile_$BENCHMARK_NAME
mpi_env ${IP_ARRAY[$FRONTEND_INDEX]}
stratuslab_repo ${IP_ARRAY[$FRONTEND_INDEX]}


for j in "${!IP_ARRAY[@]}"; do
if [ $j != $FRONTEND_INDEX ]; then
echo "Copying ssh key to ${IP_ARRAY[$j]}  Virtual Machine "
mpi_sshkey_copy ${IP_ARRAY[$j]}
mpi_env ${IP_ARRAY[$j]}
stratuslab_repo ${IP_ARRAY[$j]}
fi
done



#Run mpi benchmarks

echo "Running mpi Benchmark"

run_benchmarks ${IP_ARRAY[$FRONTEND_INDEX]} $Executable  hostfile_$BENCHMARK_NAME $CPU





echo "Retrieving results"

get_output ${IP_ARRAY[$FRONTEND_INDEX]} $Executable $RESULTS


echo "clean" 

mpi_clean
