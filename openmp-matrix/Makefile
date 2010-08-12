CC = gfortran -fopenmp
CXX = gcc -fopenmp
CCC = gcc -fopenmp
F77 = gfortran -fopenmp
FC =  gfortran -fopenmp
FCS =  gfortran 

CFLAGS = -g
CXXFLAGS = -g
CCFLAGS = -g
FFLAGS = -g
FCFLAGS = -g

CMD     = openmp-matrix
SRC     = openmp-matrix.f90
OBJ     = openmp-matrix.o


all:    openmp-matrix_seq openmp-matrix_para

openmp-matrix_seq: openmp-matrix.f90   
	mkdir -p bin
	$(FCS) $(FFLAGS) $^ -o bin/$@
openmp-matrix_para: openmp-matrix.f90 
	$(FC) $(FFLAGS) $^ -o bin/$@ 

clean:
	rm -rf bin  *.o 

