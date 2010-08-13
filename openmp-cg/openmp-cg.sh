#!/bin/bash
if [ -z "$1" ];
then
  echo "Usage ./openmp-cg.sh rowsNb"
  exit
else
export PATH=.:$PATH
# Sequential Execution 
openmp-cg_seq $1

# Parallel Execution :  1 thread
export OMP_NUM_THREADS=1
openmp-cg_para $1

# Parallel Execution : 2 threads
export OMP_NUM_THREADS=2
openmp-cg_para $1

# Parallel Execution : 4 threads
export OMP_NUM_THREADS=4
openmp-cg_para $1

# Parallel Execution : 6 threads
export OMP_NUM_THREADS=6
openmp-cg_para $1

# Parallel Execution : 8 threads
export OMP_NUM_THREADS=8
openmp-cg_para $1
fi
