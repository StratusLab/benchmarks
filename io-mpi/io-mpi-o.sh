#!/bin/bash

if [ -z $1 ]
then
  echo "Usage /usr/libexec/io-mpi-o.sh Outputfile_size(Mbytes) ) "
  exit
else
  mpirun --mca btl tcp,self -np $1  --byslot /usr/libexec/io-mpi-o $1  | sort 
fi
