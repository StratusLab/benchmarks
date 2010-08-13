#!/bin/bash

if [ -z $1 -o -z $2 ]
then
  echo "Usage /usr/libexec/io-mpi.sh file1_size(Mbytes) file1_size(Mbytes) "
  exit
else
  mpirun --mca btl tcp,self -np $1  --byslot /usr/libexec/io-mpi-io $1 $2 | sort 
fi
