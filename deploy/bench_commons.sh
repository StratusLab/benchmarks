SCRIPT_NAME=`basename $0`



function clean()
{
onevm delete $VM_NAME
rm vm-template-$VM_NAME
sleep 10
}
function mpi_clean()
{
echo "rm hostfile_$BENCHMARK_NAME"
rm hostfile_$BENCHMARK_NAME
rm mpi_key.pub
for j in "${VMNAME_ARRAY[@]}"; do
echo "onevm delete $j"
onevm delete $j
echo "rm vm-template-$j"
rm vm-template-$j
done
sleep 10
}

function cleanall()
{
if [ -e "hostfile_$BENCHMARK_NAME" ]; then
mpi_clean
else
clean
fi
}

function log
{
    echo "$SCRIPT_NAME: $1"
}

function log_error
{
    log "ERROR: $1"
}

function error_message
{
    (
        echo "ERROR MESSAGE --------"
        echo "$1"
        echo "ERROR MESSAGE --------"
    ) 1>&2
}



function exec_and_log
{
    output=`$1 2>&1 1>/dev/null`
    code=$?
    if [ "x$code" != "x0" ]; then
        log_error "Command \"$1\" failed."
        log_error "$output"
        error_message "$output"
        exit $code
    fi
    log "Executed \"$1\"."
}


function execute()
{
    ret=`$1 2>&1 1>/dev/null`
    check=$?
    if [ "$check" != "0" ]; then
        echo "$SCRIPT_NAME: ERROR : Command \"$1\" failed."
        echo "$SCRIPT_NAME: ERROR : $ret"
        echo "ERROR MESSAGE : $ret"
        cleanall 
        exit $check
    fi
    echo "Executed $SCRIPT_NAME: $1."
}



function logfile()
{
mkdir -p $2/Outputs/$1-$$
exec > $2/Outputs/$1-$$/$1-$$.log 2>&1
}

function check_vm_status()
{
    LIMIT_TIME=$2
    INITIAL_TIME=`date +%s`
    CURRENT_TIME=`date +%s`
    let "TEST_TIME = $CURRENT_TIME - $INITIAL_TIME"

    VM_STATUS=(`onevm show $1 | grep "STATE" | awk '{print $3}'`)
    while [ "${VM_STATUS[1]}" != "RUNNING" -a "${VM_STATUS[0]}" != "FAILED" ] && [ $TEST_TIME -lt $LIMIT_TIME ]; do
    VM_STATUS=(`onevm show $1 | grep "STATE" | awk '{print $3}'`)
    echo "VM $1 Status : ${VM_STATUS[1]}"
    sleep 30
    CURRENT_TIME=`date +%s`
    let "TEST_TIME = $CURRENT_TIME - $INITIAL_TIME"
    done
}


function check_vm_network()
{
    LIMIT_TIME=$2
    INITIAL_TIME=`date +%s`

    CURRENT_TIME=`date +%s`
    VM_CONNECTION_STATUS=`ping -w 20  $1 | grep $1  | wc -l`
    if [ -z "$VM_CONNECTION_STATUS" ]; then
        echo "Unable to connect to  VM!"
        exit -1
    fi
    let "TEST_TIME = $CURRENT_TIME - $INITIAL_TIME"
    while [ "$VM_CONNECTION_STATUS" == 2 ] &&  [ $TEST_TIME -lt $LIMIT_TIME ]; do
    VM_CONNECTION_STATUS=`ping -w 20  $1 | grep $1  | wc -l`
    sleep 30
    CURRENT_TIME=`date +%s`
    let "TEST_TIME = $CURRENT_TIME - $INITIAL_TIME"
    done
}


function vm_template() 
{
sed -e "s|VMNAME|$1|g" -e "s|NBVCPU|$2|g" -e "s|NBCPU|$2|g" -e "s|TMEMORY|$3|g" vm-template > vm-template-$1
}
# Submit VM

function vm_submit() 
{
onevm submit vm-template-$1
}

#Get IPADDRESS Of VM

function ipaddress_vm() 
{
IPADDRESS=`onevm show $1 | grep "IP" | cut -f2 -d"=" | cut -f1 -d","`
}


#Check Virtual Machine Status



function stratuslab_repo()
{
scp stratuslab.repo root@$1:/etc/yum.repos.d
execute "ssh root@$1 yum install -y  stratuslab-benchmarks"
}

function run_benchmarks()
{
ssh root@$1 $2 $3 $4 $5
}


function get_output()
{
mkdir -p $3
execute "scp root@$1:/root/*.xml $3"
}

function copy_file()
{
execute "scp $2 root@$1:"
}



