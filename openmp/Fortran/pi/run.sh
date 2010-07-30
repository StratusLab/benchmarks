# Execution monoprocesseur
./pi_seq

# Execution parallele avec 1 thread
export OMP_NUM_THREADS=1
#export OMP_SCHEDULE="STATIC"
./pi_omp

# Execution parallele avec 2 threads
export OMP_NUM_THREADS=2
#export OMP_SCHEDULE="STATIC"
./pi_omp
# Execution parallele avec 4 threads
export OMP_NUM_THREADS=4
#export OMP_SCHEDULE="STATIC"
./pi_omp
# Execution parallele avec 6 threads
export OMP_NUM_THREADS=6
#export OMP_SCHEDULE="STATIC"
./pi_omp
# Execution parallele avec 8 threads
export OMP_NUM_THREADS=8
#export OMP_SCHEDULE="STATIC"
./pi_omp
