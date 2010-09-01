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


all:    openmp-cg_seq openmp-cg_para


openmp-cg_seq: src/openmp-cg.f90
	mkdir -p bin
	$(FFC) $(LDFLAGS) $^ -o bin/$@

openmp-cg_para: src/openmp-cg.f90 
	$(FC) $(LDFLAGS) $^ -o bin/$@

clean:
	rm -rf bin *.o 

