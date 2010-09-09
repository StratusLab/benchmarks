. bench_commons.sh

function hostfile_mpi()
{
sed  -e "s|NBVCPU|$1|g" -e "s|ipaddress|$2|g" hostfile >> hostfile_$3
}




function submit_mpi_vm()
{
#Create VM template

vm_template $VM_NAME$k-$i $i $(($MEMCPU*$i))

#Submit VM

vm_submit $VM_NAME$k-$i

#Get VM address

ipaddress_vm $VM_NAME$k-$i

# Array ip&vm increment 

IP_ARRAY[$k]=$IPADDRESS
VMNAME_ARRAY[$k]=$VM_NAME$k-$i

#mpi hostfile

hostfile_mpi $i ${IP_ARRAY[$k]} $BENCHMARK_NAME

#Next iteration

let "k = $k + 1"
}
function available_cpu()
{
ACPU=`onehost -l acpu list | sed '1d' | sort -n -r`

for i in $ACPU ; do let  "tacpu = $tacpu + $i"; done;

let "tcpu = $tacpu/100"

if [ $tcpu -lt $CPU ]; then
echo "Number of available CPU  =" $tcpu
exit -1
fi
}

function available_memory()
{
FMEM=`onehost -l fmem list | sed '1d' | sort -n -r`;
for i in $FMEM ; do let  "tfmem = $tfmem + $i"; done;

let "tfmem = $tfmem*100"

if [ $tfmem -lt $MEMORY ]; then
echo "Total Free Memory Available(Mbytes) =" $tfmem
exit -1
fi
}



function available_cpu_max()
{
ACPUMAX=`onehost -l acpu list | sed '1d' | sort -n -r | head -1`
ACPUMAX=$((ACPUMAX/100))
}

function submit_mpi_cluster()
{
let "k = 0"
available_cpu_max
if [ $ACPUMAX -gt $1 ]; then
i=$1
echo "Submitting $VM_NAME$k-$i Virtual Machine"
submit_mpi_vm
else
ALCPU=0
for i in $ACPU ; do
let "i=$i/100"

if [[ $ALCPU -lt $1 && $(($1 - $ALCPU)) -ge $i ]]; then
let "ALCPU=$ALCPU+$i"
echo "Submitting $VM_NAME$k-$i Virtual Machine"
submit_mpi_vm
elif [[ $ALCPU -lt $1 && $(($1 - $ALCPU)) -lt $i ]]; then
let "i=$1 - $ALCPU"
echo "Submitting $VM_NAME$k-$i Virtual Machine"
submit_mpi_vm
break
fi
done
fi
}
function mpi_sshkey_gen()
{
ssh root@$1  ssh-keygen -q -N \"\" -f /root/.ssh/id_rsa
scp root@$1:/root/.ssh/id_rsa.pub  mpi_key.pub
}

function mpi_sshkey_copy()
{
scp mpi_key.pub root@$1:/root/.ssh/
ssh root@$1 cat /root/.ssh/mpi_key.pub \>\> /root/.ssh/authorized_keys
}
function mpi_env()
{
ssh root@$1 "echo export PATH=/usr/lib64/openmpi/1.4-gcc/bin:'$'PATH >> /root/.bashrc"
}
