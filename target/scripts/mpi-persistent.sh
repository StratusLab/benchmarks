#!/bin/bash

if [ -z $1 ]
then
  echo "Usage ./mpi-persistent.sh ThreadNb"
  exit
else
  mpirun --mca btl tcp,self  -np $1  --byslot mpi-persistent | sort 
fi
