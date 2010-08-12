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




OBJS = io-mpi-o.o io-mpi-i.o io-mpi-io.o

all:	io-mpi-o io-mpi-i io-mpi-io

io-mpi-o : io-mpi-o.f90
	mkdir -p bin
	$(FC) $(FCFLAGS) $^ -o bin/$@

io-mpi-i : io-mpi-i.f90
	$(FC) $(FCFLAGS) $^ -o bin/$@
io-mpi-io :  io-mpi-io.f90
	$(FC) $(FCFLAGS) $^ -o bin/$@
clean :
	rm -rf bin$(OBJS) 
