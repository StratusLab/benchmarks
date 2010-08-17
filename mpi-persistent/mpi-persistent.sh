#!/bin/bash

if [ -z $1 ]
then
  echo "Usage /usr/libexec/mpi-persistent.sh ThreadNb"
  exit
fi
  mpirun --mca btl tcp,self  -np $1  --byslot /usr/libexec/mpi-persistent | sort 
