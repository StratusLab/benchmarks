# Used for log messages
SCRIPT_NAME=`basename $0`

# Formats date for logs
function log_date
{
    date +"%a %b %d %T %Y"
}

# Logs a message
function log
{
    echo "$SCRIPT_NAME: $1"
}

# Logs an error message
function log_error
{
    log "ERROR: $1"
}

# This function is used to pass error message to the mad
function error_message
{
    (
        echo "ERROR MESSAGE --8<------"
        echo "$1"
        echo "ERROR MESSAGE ------>8--"
    ) 1>&2
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
ssh root@$1 yum install -y  stratuslab-benchmarks
}

function run_benchmarks()
{
ssh root@$1 $2 $3 $4 $5
}


function get_output()
{
scp root@$1:/root/$2.xml $3
}

function copy_file()
{
scp $2 root@$1:
}

function clean()
{
onevm delete $1
rm vm-template-$1
}

