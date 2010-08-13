#!/bin/bash
if [ -z "$1" ];
then
  echo "Usage /usr/libexec/openmp-jacobi.sh rowsNb"
  exit
else
export PATH=.:$PATH
# Sequential Execution 
/usr/libexec/openmp-jacobi_seq $1

# Parallel Execution : 8 threads
export OMP_NUM_THREADS=8
/usr/libexec/openmp-jacobi_para $1
fi
