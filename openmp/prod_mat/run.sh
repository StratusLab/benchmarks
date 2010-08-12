#!/bin/bash
if [ -z "$1" -o -z "$2" ];
then
  echo "Usage ./run.sh rowsNb columnsNb"
  exit
else
export PATH=.:$PATH
# Sequential Execution
prod_mat_seq $1 $2

# Parallel Execution 1 thread
export OMP_NUM_THREADS=1
prod_mat_omp  $1 $2

# Parallel execution  2 threads
export OMP_NUM_THREADS=2
prod_mat_omp  $1 $2
# Parallel Execution  4 threads
export OMP_NUM_THREADS=4
prod_mat_omp  $1 $2
# Parallel execution  6 threads
export OMP_NUM_THREADS=6
prod_mat_omp  $1 $2
# Parallel execution 8 threads
export OMP_NUM_THREADS=8
prod_mat_omp  $1 $2
fi
