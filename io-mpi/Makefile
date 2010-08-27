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

all:	io-o io-i io-io

io-o : src/io-mpi-o.f90
	mkdir -p bin
	$(FC) $(FCFLAGS) $^ -o bin/$@

io-i : src/io-mpi-i.f90
	$(FC) $(FCFLAGS) $^ -o bin/$@
io-io :  src/io-mpi-io.f90
	$(FC) $(FCFLAGS) $^ -o bin/$@
clean :
	rm -rf bin $(OBJS) 
