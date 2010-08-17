#!/bin/bash
if [ -z "$1" ];
then
  echo "Usage /usr/libexec/openmp-jacobi.sh ThreadNb"
  exit
fi

# Sequential Execution 
/usr/libexec/openmp-jacobi_seq 

# Parallel Execution : 8 threads
export OMP_NUM_THREADS=$1
/usr/libexec/openmp-jacobi_para 

