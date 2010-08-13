#!/bin/bash

if [ -z $1 -o -z $2 ]; then
"Usage : ./cpu_intensive  cpuNb timeout(sec)"
else
./cpu_intensive -c $1 -t $2
fi
