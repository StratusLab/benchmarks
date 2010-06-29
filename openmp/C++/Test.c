#include <stdio.h>
#include <omp.h>

int main(int argc, char *argv[]) {
  int tnb = 0, np = 1;

  #pragma omp parallel default(shared) private(tnb, np)
  {
    #if defined (_OPENMP)
      np = omp_get_num_threads();
      tnb = omp_get_thread_num();
    #endif
    printf("Thread Number %d out of %d\n", tnb, np);
  }
}

