CC = gfortran -fopenmp
CXX = gcc -fopenmp
CCC = gcc -fopenmp
F77 = gfortran -fopenmp
FC =  gfortran -fopenmp
FCS = gfortran

CFLAGS = -g
CXXFLAGS = -g
CCFLAGS = -g
FFLAGS = -g
FCFLAGS = -g

CMD     = openmp-jacobi
SRC     = openmp-jacobi.f90
OBJ     = openmp-jacobi.o


all:    openmp-jacob_seq openmp-jacobi_para

openmp-jacob_seq: openmp-jacobi.f90 
	mkdir -p bin
	$(FCS) $(FFLAGS) $^ -o bin/$@

openmp-jacobi_para: openmp-jacobi.f90
	$(FC) $(FFLAGS) $^ -o bin/$@

clean:
	rm -rf bin *.o 

