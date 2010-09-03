FC =  gfortran -fopenmp
FCS =  gfortran 

FFLAGS = -g


all:    openmp-matrix_seq openmp-matrix_para

openmp-matrix_seq: src/openmp-matrix.f90   
	mkdir -p bin
	$(FCS) $(FFLAGS) $^ -o bin/$@
openmp-matrix_para: src/openmp-matrix.f90 
	$(FC) $(FFLAGS) $^ -o bin/$@ 

clean:
	rm -rf bin  *.o 

