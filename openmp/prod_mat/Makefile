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

CMD     = prod_mat
SRC     = prod_mat.f90
OBJ     = prod_mat.o


all:    seq para

seq:
	$(FCS) $(FCFLAGS) -c $(SRC)
	$(FCS) $(LDFLAGS) -o $(CMD)_seq $(OBJ)

para: 
	$(FC) $(FFLAGS) $(OMP) -c $(SRC)
	$(FC) $(LDFLAGS) $(OMP) -o $(CMD)_omp $(OBJ)


clean:
	rm -f $(CMD)_omp $(CMD)_seq *.o 

