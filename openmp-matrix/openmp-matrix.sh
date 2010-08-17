#!/bin/bash
if [ -z "$1" ];
then
  echo "Usage /usr/libexec/openmp-matrix.sh ThreadNb"
  exit
fi

# Sequential Execution
/usr/libexec/openmp-matrix_seq 

# Parallel execution 8 threads
export OMP_NUM_THREADS=$1
/usr/libexec/openmp-matrix_para  

