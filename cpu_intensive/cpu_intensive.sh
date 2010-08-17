#!/bin/bash

if [ -z $1 -o -z $2 ]; then
echo "Usage : /usr/libexec/cpu_intensive  cpuNb timeout(sec)"
exit
fi
/usr/libexec/cpu_intensive -c $1 -t $2
