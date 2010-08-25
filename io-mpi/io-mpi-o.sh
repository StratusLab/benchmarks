#!/bin/bash

if [ -z $1 -o -z $2 ]
then
  echo "Usage /usr/bin/io-mpi-o.sh  ThreadNb Outputfile_size(Mbytes) ) "
  exit
fi  
mpirun --mca btl tcp,self  -np $1 /usr/libexec/io-mpi-o $1 $2   
