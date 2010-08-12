CC = gfortran -fopenmp
CXX = gcc -fopenmp
CCC = gcc -fopenmp
F77 = gfortran -fopenmp
FC =  gfortran -fopenmp
FFC =  gfortran

CFLAGS = -g
CXXFLAGS = -g
CCFLAGS = -g
FFLAGS = -g
FCFLAGS = -g

CMD     = openmp-cg
SRC     = openmp-cg.f90
OBJ     = openmp-cg.o

all:    openmp-cg_seq openmp-cg_para


openmp-cg_seq: openmp-cg.f90
	mkdir -p bin
	$(FFC) $(LDFLAGS) $^ -o bin/$@

openmp-cg_para: openmp-cg.f90 
	$(FFC) $(LDFLAGS) $^ -o bin/$@

clean:
	rm -rf bin *.o 

