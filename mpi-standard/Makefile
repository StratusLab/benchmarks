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
LDFLAGS = -L/usr/lib64 -llapack




OBJS = mpi-standard.o

all:	mpi-stand

mpi-stand : src/mpi-standard.f90
	mkdir -p bin
	$(FC) $(FCFLAGS) $^ -o bin/$@ $(LDFLAGS)

clean :
	rm -rf bin $(OBJS) 
