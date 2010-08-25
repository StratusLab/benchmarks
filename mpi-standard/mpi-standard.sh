#!/bin/bash

if [ -z $1 -o -z $2 ]
then
  echo "Usage /usr/bin/mpi-standard.sh hostfile ThreadNb"
  exit
fi  
mpirun --mca btl tcp,self --hostfile $1 -np $2  /usr/libexec/mpi-standard 

