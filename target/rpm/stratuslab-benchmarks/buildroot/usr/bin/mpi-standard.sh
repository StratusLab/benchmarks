#!/bin/bash

if [ -z $1 ]
then
  echo "Usage ./mpi-standard.sh ThreadNb"
  exit
else
  mpirun --mca btl tcp,self   -np $1  --byslot mpi-standard | sort
fi
