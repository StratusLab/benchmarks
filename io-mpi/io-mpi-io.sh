#!/bin/bash

if [ -z $1 -o -z $2 -o -z $3 ]
then
  echo "Usage /usr/bin/io-mpi-io.sh ThreadNb Inputfile_size(Mbytes) Outputfile_size(Mbytes) "
  exit
fi  

mpirun --mca btl tcp,self   -np $1  /usr/libexec/io-mpi-o $1 $2 

mpirun --mca btl tcp,self  -np $1 /usr/libexec/io-mpi-io $1 $2 $3  
