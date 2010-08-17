#!/bin/bash

if [ -z $1 ]
then
  echo "Usage /usr/libexec/io-mpi-i.sh Inputfile_size(Mbytes)  "
  exit
fi  
mpirun --mca btl tcp,self -np $1  --byslot /usr/libexec/io-mpi-i $1 | sort 
