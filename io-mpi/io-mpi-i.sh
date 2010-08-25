#!/bin/bash

if [ -z $1 -o -z $2 ]
then
  echo "Usage /usr/bin/io-mpi-i.sh  ThreadNb Inputfile_size(Mbytes)  "
  exit
fi  
mpirun --mca btl tcp,self -np  $1  /usr/libexec/io-mpi-i $1 $2 
