# Sequential Execution
./prod_mat_seq

# Parallel Execution 1 thread
export OMP_NUM_THREADS=1
echo $OMP_NUM_THREADS

./prod_mat_omp

# Parallel execution  2 threads
export OMP_NUM_THREADS=2
./prod_mat_omp
# Parallel Execution  4 threads
export OMP_NUM_THREADS=4
./prod_mat_omp
# Parallel execution  6 threads
export OMP_NUM_THREADS=6
./prod_mat_omp
# Parallel execution 8 threads
export OMP_NUM_THREADS=8
./prod_mat_omp
