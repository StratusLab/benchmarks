#!/bin/bash
if [ -z "$1" ];
then
  echo "Usage /usr/libexec/openmp-cg.sh rowsNb"
  exit
else
export PATH=.:$PATH
# Sequential Execution 
/usr/libexec/openmp-cg_seq $1

# Parallel Execution :  1 thread
export OMP_NUM_THREADS=1
/usr/libexec/openmp-cg_para $1

# Parallel Execution : 8 threads
export OMP_NUM_THREADS=8
/usr/libexec/openmp-cg_para $1
fi
