#!/bin/bash
if [ -z "$1" ];
then
  echo "Usage /usr/bin/openmp-jacobi.sh ThreadNb"
  exit
fi

# Sequential Execution 
/usr/libexec/openmp-jacobi_seq 

# Parallel Execution 
export OMP_NUM_THREADS=$1
/usr/libexec/openmp-jacobi_para 

