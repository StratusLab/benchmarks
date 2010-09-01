#!/bin/bash
function Usage()
{
echo "Usage : mpi_benchmarks.sh -e Executable -c CPUNb -m MemorySize(Mbytes)"

echo "where :

Executable : mpi-async, mpi-sync, mpi-persistent or mpi-standard.
CPUNb : Number of CPU to use
MemorySize : Amount of Memory to use (Mbytes)

Example : openmp_benchmarks -e mpi-sync  -c 3 -m 3000
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





echo "MEMORY=$MEMORY"
echo "CPU=$CPU"
echo "Executable=$Executable"







BENCHMARK_NAME=$Executable 
VM_NAME=mpi$CPU

RESULTS=/home/oneadmin/results


IP_ARRAY=();
VMNAME_ARRAY=();

function check_vm_status()
{
    LIMIT_TIME=600
    INITIAL_TIME=`date +%s`
    CURRENT_TIME=`date +%s`
    let "TEST_TIME = $CURRENT_TIME - $INITIAL_TIME"
    
    VM_STATUS=`onevm show $j | grep "LCM_STATE" | awk '{print $3}'`

    while [ "$VM_STATUS" != "RUNNING" -a "$VM_STATUS" != "FAILED" ] && [ $TEST_TIME -lt $LIMIT_TIME ]; do
    VM_STATUS=`onevm show $j | grep "LCM_STATE" | awk '{print $3}'`
    echo "VM $j Status : $VM_STATUS"
    sleep 30
    CURRENT_TIME=`date +%s`
    let "TEST_TIME = $CURRENT_TIME - $INITIAL_TIME"
    done
}





function check_vm_network()
{
    LIMIT_TIME=300
    INITIAL_TIME=`date +%s`

    CURRENT_TIME=`date +%s`
    VM_REACH_STATUS=`ping -w 20  $j | grep $j  | wc -l`
    if [ -z "$VM_REACH_STATUS" ]; then
        echo "Unable to connect to  VM!"
        exit -1
    fi
    let "TEST_TIME = $CURRENT_TIME - $INITIAL_TIME"
    while [ "$VM_REACH_STATUS" == 2 ] &&  [ $TEST_TIME -lt $LIMIT_TIME ]; do
    VM_REACH_STATUS=`ping -w 20  $j | grep $j  | wc -l`
    sleep 30
    CURRENT_TIME=`date +%s`
    let "TEST_TIME = $CURRENT_TIME - $INITIAL_TIME"
    done
}


function submit_vm()
{
sed  -e "s|VMNAME|$VM_NAME$k-$i|g"  -e "s|NBVCPU|$i|g" -e "s|NBCPU|$i|g" -e "s|TMEMORY|$(($MEMCPU*$i))|g" vm-template > vm-template-$VM_NAME$k-$i
onevm submit vm-template-$VM_NAME$k-$i
IPADDRESS=`onevm show $VM_NAME$k-$i | grep "IP" | cut -f2 -d"=" | cut -f1 -d","`
IP_ARRAY[$k]=$IPADDRESS
echo "IPADDRESS=$IPADDRESS"
VMNAME_ARRAY[$k]=$VM_NAME$k-$i
sed  -e "s|NBVCPU|$i|g" -e "s|ipaddress|${IP_ARRAY[$k]}|g" hostfile >> hostfile_$BENCHMARK_NAME
let "k = $k + 1"
}



function hostfile_mpi()
{
for i in "${!IP_ARRAY[@]}"; do
sed  -e "s|NBVCPU|$i|g" -e "s|ipaddress|${IP_ARRAY[$i]}|g" hostfile >> hostfile_$BENCHMARK_NAME
done
}



ACPU=`onehost -l acpu list | sed '1d' | sort -n -r`
ACPUMAX=`onehost -l acpu list | sed '1d' | sort -n -r | head -1`

for i in $ACPU ; do let  "tacpu = $tacpu + $i"; done;

let "tcpu = $tacpu/100"
let "tcpu = $tacpu-1"

if [ $tcpu -lt $CPU ]; then
echo "Number of available CPU  =" $tcpu
exit -1
fi


FMEM=`onehost -l fmem list | sed '1d' | sort -n -r`;
for i in $FMEM ; do let  "tfmem = $tfmem + $i"; done;

let "tfmem = $tfmem*100"

if [ $tfmem -lt $MEMORY ]; then
echo "Total Free Memory Available(Mbytes) =" $tfmem
exit -1
fi


let "MEMCPU = $MEMORY/$CPU"

ACPUMAX=$((ACPUMAX/100))


let "k = 0"

if [ $ACPUMAX -gt $CPU ]; then
i=$CPU
echo "Submitting $VM_NAME$k-$i Virtual Machine"
submit_vm
else
ALCPU=0
for i in $ACPU ; do
let "i=$i/100"

#if [ $i == $ACPUMAX ]; then
#let "i=$i-2"
#fi

if [[ $ALCPU -lt $CPU && $(($CPU - $ALCPU)) -ge $i ]]; then                 
let "ALCPU=$ALCPU+$i"
echo "Submitting $VM_NAME$k-$i Virtual Machine"
submit_vm
elif [[ $ALCPU -lt $CPU && $(($CPU - $ALCPU)) -lt $i ]]; then
let "i=$CPU - $ALCPU"
echo "Submitting $VM_NAME$k-$i Virtual Machine"
submit_vm
break
fi
done
fi


echo "Adresses IP : ${IP_ARRAY[*]}"



for j in "${VMNAME_ARRAY[@]}"; do
echo "Checking  $j Virtual Machine Status" 
check_vm_status
if [ $VM_STATUS != "RUNNING" ]; then
echo "Unable to start $j VM!"
exit -1
fi
done


for j in "${IP_ARRAY[@]}"; do
echo "Checking  $j Virtual Machine Network" 
check_vm_network
if  [ "$VM_CONNECTION_STATUS" == "2" ]; then
echo "Unable to reach $j VM!"
exit -1
fi
done



for j in "${IP_ARRAY[@]}"; do
echo "Copying hostfile to $j  Virtual Machine "
scp hostfile_$BENCHMARK_NAME root@$j:
done






#mpi-sync

FRONTEND_INDEX=`echo ${!IP_ARRAY[*]} | cut -f1 -d" "`
echo "FRONTEND_INDEX=$FRONTEND_INDEX"

#mpicluster

ssh root@${IP_ARRAY[$FRONTEND_INDEX]}  ssh-keygen -q -N \"\" -f /root/.ssh/id_rsa
scp root@${IP_ARRAY[$FRONTEND_INDEX]}:/root/.ssh/id_rsa.pub  mpi_key.pub

scp stratuslab.repo root@${IP_ARRAY[$FRONTEND_INDEX]}:/etc/yum.repos.d
ssh root@${IP_ARRAY[$FRONTEND_INDEX]} yum install -y  stratuslab-benchmarks

for j in "${!IP_ARRAY[@]}"; do
if [ $j != $FRONTEND_INDEX ]; then
echo "Copying ssh key to ${IP_ARRAY[$j]}  Virtual Machine "
scp mpi_key.pub root@${IP_ARRAY[$j]}:/root/.ssh/
ssh root@${IP_ARRAY[$j]} cat /root/.ssh/mpi_key.pub \>\> /root/.ssh/authorized_keys

scp stratuslab.repo root@${IP_ARRAY[$j]}:/etc/yum.repos.d
ssh root@${IP_ARRAY[$j]} yum install -y  stratuslab-benchmarks
fi
done



#Run
echo "Running mpi Benchmark"
ssh root@${IP_ARRAY[$FRONTEND_INDEX]} $Executable  hostfile_$BENCHMARK_NAME $CPU





echo "Retrieving results"

scp root@${IP_ARRAY[$FRONTEND_INDEX]}:/root/$Executable.xml $RESULTS


echo "clean" 
echo "rm hostfile_$BENCHMARK_NAME"
rm hostfile_$BENCHMARK_NAME 
rm mpi_key.pub
for j in "${VMNAME_ARRAY[@]}"; do
echo "onevm delete $j"
onevm delete $j
echo "rm vm-template-$j"
rm vm-template-$j 
done

