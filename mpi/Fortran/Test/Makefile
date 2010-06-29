CC = mpicc
CXX = mpic++
CCC = mpic++
F77 = mpif77
FC = mpif90


CFLAGS = -g
CXXFLAGS = -g
CCFLAGS = -g
F77FLAGS = -g
FCFLAGS = -g



all: Test

clean:
	rm -f *~ *.o Test


Test: Test.f90
	$(FC) $(FCFLAGS) $^ -o $@

