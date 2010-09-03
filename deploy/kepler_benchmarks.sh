#!/bin/bash

function Usage()
{  
echo "Usage : kepler_benchmarks.sh -e Executable -c CPUNb -m MemorySize(Mbytes) -w workflow"
  
echo "where :

Executable : kepler-nogui
CPUNb : Number of CPU to use
MemorySize : Amount of Memory to use in Mbytes
kepler_workflow : Kepler workflow in xml format

Example : kepler_benchmarks.sh -e kepler-nogui -c 3 -m 3000  -w myWorkflow.xml
"
    
exit -1
}   
    


while getopts c:m:w:e: args 
do  
 case $args in
  m)
   MEMORY=$OPTARG
   ;;
  c)
   CPU=$OPTARG
   ;;
  w)
   Workflow=$OPTARG
   ;;
  e)
   Executable=$OPTARG
   ;;
  *) Usage
   ;;
 esac
done

[ -z "$Workflow" -o -z "$Executable" -o -z "$CPU" -o -z "$MEMORY" ] && Usage

echo "Workflow=$Workflow"






. bench_commons.sh

logfile $Executable $PWD

VM_NAME=workflow-bench$CPU
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



#Workflow Bench

#Benchmarks install from stratuslab yum repository

stratuslab_repo ${IPADDRESS}

echo "copying $Workflow"

copy_file ${IPADDRESS} $Workflow

echo "run $Executable  benchmark"

run_benchmarks $IPADDRESS $Executable /root/${Workflow##*/}

echo "retrieving $Executable  benchmark results"

#Get Outputs 
echo "retrieving $Executable  benchmark results"

get_output ${IPADDRESS} $Executable $RESULTS

#Clean

clean $VM_NAME


