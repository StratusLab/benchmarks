#!/bin/bash
if [ -z "$1" -o -z "$2" ];
then
  echo "Usage /usr/libexec/openmp-matrix.sh rowsNb columnsNb"
  exit
else
export PATH=.:$PATH
# Sequential Execution
/usr/libexec/openmp-matrix_seq $1 $2

# Parallel execution 8 threads
export OMP_NUM_THREADS=8
/usr/libexec/openmp-matrix_para  $1 $2
fi
