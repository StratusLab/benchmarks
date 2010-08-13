#!/bin/bash

if [ -z $1 ]
then
  echo "Usage /usr/libexec/mpi-standard.sh ThreadNb"
  exit
else
  mpirun --mca btl tcp,self   -np $1  --byslot /usr/libexec/mpi-standard | sort
fi
