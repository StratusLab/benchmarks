#!/bin/bash

if [ -z $1 -o -z $2 ]
then
  echo "Usage /usr/libexec/io-mpi-io.sh Inputfile_size(Mbytes) Outputfile_size(Mbytes) "
  exit
fi  
mpirun --mca btl tcp,self -np $1  --byslot /usr/libexec/io-mpi-io $1 $2 | sort 
