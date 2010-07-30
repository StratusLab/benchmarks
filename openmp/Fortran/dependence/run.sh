# Execution monoprocesseur
./dependance_seq

# Execution parallele avec 1 thread
export OMP_NUM_THREADS=1
./dependance_omp

# Execution parallele avec 2 threads
export OMP_NUM_THREADS=2
./dependance_omp
# Execution parallele avec 4 threads
export OMP_NUM_THREADS=4
./dependance_omp
# Execution parallele avec 6 threads
export OMP_NUM_THREADS=6
./dependance_omp
# Execution parallele avec 8 threads
export OMP_NUM_THREADS=8
./dependance_omp
