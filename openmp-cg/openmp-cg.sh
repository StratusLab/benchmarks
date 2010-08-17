#!/bin/bash
if [ -z "$1" ];
then
  echo "Usage /usr/libexec/openmp-cg.sh ThreadNb"
  exit
fi

# Sequential Execution 
/usr/libexec/openmp-cg_seq 


# Parallel Execution : Nbthreads
export OMP_NUM_THREADS=$1
/usr/libexec/openmp-cg_para 

