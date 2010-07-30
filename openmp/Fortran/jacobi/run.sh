# Execution monoprocesseur
./jacobi_seq

# Execution parallele avec 1 thread
export OMP_NUM_THREADS=1
./jacobi_seq

# Execution parallele avec 2 threads
export OMP_NUM_THREADS=2
./jacobi_omp
# Execution parallele avec 4 threads
export OMP_NUM_THREADS=4
./jacobi_omp
# Execution parallele avec 6 threads
export OMP_NUM_THREADS=6
./jacobi_omp
# Execution parallele avec 8 threads
export OMP_NUM_THREADS=8
./jacobi_omp

