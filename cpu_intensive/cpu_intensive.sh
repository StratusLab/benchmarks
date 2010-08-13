#!/bin/bash

if [ -z $1 -o -z $2 ]; then
"Usage : /usr/libexec/cpu_intensive  cpuNb timeout(sec)"
else
/usr/libexec/cpu_intensive -c $1 -t $2
fi
