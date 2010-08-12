#!/bin/bash
if [ -z "$1" ];
then
  echo "Usage ./run.sh rowsNb"
  exit
else
export PATH=.:$PATH
# Sequential Execution 
cg_seq $1

# Parallel Execution :  1 thread
export OMP_NUM_THREADS=1
cg_omp $1

# Parallel Execution : 2 threads
export OMP_NUM_THREADS=2
cg_omp $1

# Parallel Execution : 4 threads
export OMP_NUM_THREADS=4
cg_omp $1

# Parallel Execution : 6 threads
export OMP_NUM_THREADS=6
cg_omp $1

# Parallel Execution : 8 threads
export OMP_NUM_THREADS=8
cg_omp $1
fi
