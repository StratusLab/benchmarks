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




OBJS = io_mpi_o.o io_mpi_i.o io_mpi_io.o

all:	io-o io-i io-io

io-o : src/io_mpi_o.f90
	mkdir -p bin
	$(FC) $(FCFLAGS) $^ -o bin/$@

io-i : src/io_mpi_i.f90
	$(FC) $(FCFLAGS) $^ -o bin/$@
io-io :  src/io_mpi_io.f90
	$(FC) $(FCFLAGS) $^ -o bin/$@
clean :
	rm -rf bin $(OBJS) 
