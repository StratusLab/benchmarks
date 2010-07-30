CC = gfortran -fopenmp
CXX = gcc -fopenmp
CCC = gcc -fopenmp
F77 = gfortran -fopenmp
FC =  gfortran -fopenmp


CFLAGS = -g
CXXFLAGS = -g
CCFLAGS = -g
FFLAGS = -g
FCFLAGS = -g

CMD     = cg
SRC     = cg.F90
OBJ     = cg.o
FFLAGS += -DVAL_N=4201

all:    mono para

mono:
	$(FC) $(FFLAGS) -c $(SRC)
	$(FC) $(LDFLAGS) -o $(CMD)_seq $(OBJ)

para: 
	$(FC) $(FFLAGS) $(OMP) -c $(SRC)
	$(FC) $(LDFLAGS) $(OMP) -o $(CMD)_omp $(OBJ)

clean:
	rm -f *.o core

cleanall:
	rm -f $(CMD)_omp $(CMD)_seq *.o core

