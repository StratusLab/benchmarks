#!/bin/bash

function Usage()
{  
echo "Usage : cpu_benchmarks.sh -e Executable -c CPUNb -m MemorySize(Mbytes) -t timeout"
  
echo "where :

Executable : cpu_intensive
CPUNb : Number of CPU to use
MemorySize : Amount of Memory to use in Mbytes
timeout : time out after N seconds

Example : cpu_benchmarks  -e cpu_intensive -c 3 -m 3000  -t 60 
"
    
exit -1
}   
    


while getopts c:m:t:e: args 
do  
 case $args in
  m)
   MEMORY=$OPTARG
   ;;
  c)
   CPU=$OPTARG
   ;;
  t)
   Timeout=$OPTARG
   ;;
  e)
   Executable=$OPTARG
   ;;
  *) Usage
   ;;
 esac
done

[ -z "$Timeout" -o -z "$Executable" -o -z "$CPU" -o -z "$MEMORY" ] && Usage


function check_vm_status()
{
    LIMIT_TIME=600
    INITIAL_TIME=`date +%s`
    CURRENT_TIME=`date +%s`
    let "TEST_TIME = $CURRENT_TIME - $INITIAL_TIME"

    VM_STATUS=`onevm show $VM_NAME | grep "LCM_STATE" | awk '{print $3}'`
    while [ "$VM_STATUS" != "RUNNING" -a "$VM_STATUS" != "FAILED" ] && [ $TEST_TIME -lt $LIMIT_TIME ]; do
    VM_STATUS=`onevm show $VM_NAME | grep "LCM_STATE" | awk '{print $3}'`
    echo "VM $VM_NAME Status : $VM_STATUS"
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
    VM_CONNECTION_STATUS=`ping -w 20  $IPADDRESS | grep $IPADDRESS  | wc -l`
    if [ -z "$VM_CONNECTION_STATUS" ]; then
        echo "Unable to connect to  VM!"
        exit -1
    fi
    let "TEST_TIME = $CURRENT_TIME - $INITIAL_TIME"
    while [ "$VM_CONNECTION_STATUS" == 2 ] &&  [ $TEST_TIME -lt $LIMIT_TIME ]; do
    VM_CONNECTION_STATUS=`ping -w 20  $IPADDRESS | grep $IPADDRESS  | wc -l`
    sleep 30
    CURRENT_TIME=`date +%s`
    let "TEST_TIME = $CURRENT_TIME - $INITIAL_TIME"
    done
}



VM_NAME=cpu_bench$CPU
RESULTS=/srv/cloud/one/results


sed -e "s|VMNAME|$VM_NAME|g" -e "s|NBVCPU|$CPU|g" -e "s|NBCPU|$CPU|g" -e "s|TMEMORY|$MEMORY|g" vm-template > vm-template-$VM_NAME

onevm submit vm-template-$VM_NAME

IPADDRESS=`onevm show $VM_NAME | grep "IP" | cut -f2 -d"=" | cut -f1 -d","`
echo "IPADDRESS=$IPADDRESS"

echo "Checking Virtual Machine Status"

check_vm_status
if [ $VM_STATUS != "RUNNING" ]; then
echo "Unable to start VM!"
exit -1
fi

echo "Checking Virtual Machine Network"

check_vm_network
if  [ $VM_CONNECTION_STATUS == "2" ]; then
echo "Unable to reach VM!"
exit -1
fi

sleep 60

#CPU Intensive


scp stratuslab.repo root@${IPADDRESS}:/etc/yum.repos.d
ssh root@${IPADDRESS} yum install -y  stratuslab-benchmarks

echo "run $Executable  benchmark"

ssh root@${IPADDRESS} $Executable $CPU $Timeout

echo "retrieving $Executable  benchmark results"

#scp root@${IPADDRESS}:/root/$Executable.xml $RESULTS

onevm delete $VM_NAME
rm vm-template-$VM_NAME


