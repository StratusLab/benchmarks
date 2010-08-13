#!/bin/bash
if [ -z "$1" -o -z "$2" ];
then
  echo "Usage ./openmp-matrix.sh rowsNb columnsNb"
  exit
else
export PATH=.:$PATH
# Sequential Execution
openmp-matrix_seq $1 $2

# Parallel Execution 1 thread
export OMP_NUM_THREADS=1
openmp-matrix_para  $1 $2

# Parallel execution  2 threads
export OMP_NUM_THREADS=2
openmp-matrix_para  $1 $2
# Parallel Execution  4 threads
export OMP_NUM_THREADS=4
openmp-matrix_para  $1 $2
# Parallel execution  6 threads
export OMP_NUM_THREADS=6
openmp-matrix_para  $1 $2
# Parallel execution 8 threads
export OMP_NUM_THREADS=8
openmp-matrix_para  $1 $2
fi
