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





OBJS = Master.o Workers.o

all:	Master Workers

Workers : Workers.F90
	$(FC) $(FCFLAGS) $^ -o $@

Master : Master.F90
	$(FC) $(FCFLAGS) $^ -o $@
clean :
	rm -f Master Workers $(OBJS) core
