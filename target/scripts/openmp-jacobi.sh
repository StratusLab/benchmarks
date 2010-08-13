#!/bin/bash
if [ -z "$1" ];
then
  echo "Usage ./openmp-jacobi.sh rowsNb"
  exit
else
export PATH=.:$PATH
# Sequential Execution 
openmp-jacobi_seq $1

# Parallel Execution :  1 thread
export OMP_NUM_THREADS=1
openmp-jacobi_para $1

# Parallel Execution : 2 threads
export OMP_NUM_THREADS=2
openmp-jacobi_para $1

# Parallel Execution : 4 threads
export OMP_NUM_THREADS=4
openmp-jacobi_para $1

# Parallel Execution : 6 threads
export OMP_NUM_THREADS=6
openmp-jacobi_para $1

# Parallel Execution : 8 threads
export OMP_NUM_THREADS=8
openmp-jacobi_para $1
fi
