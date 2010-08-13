#!/bin/bash

if [ -z $1 -o -z $2 ]
then
  echo "Usage ./io-mpi.sh file1_size(Mbytes) file1_size(Mbytes) "
  exit
else
  mpirun --mca btl tcp,self -np $1  --byslot io-mpi-io | sort 
fi
