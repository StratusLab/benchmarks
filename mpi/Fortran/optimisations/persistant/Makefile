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
LDFLAGS = -L/usr/lib64 -llapack




OBJS = persistant.o

all:	persistant

persistant : persistant.f90
	$(FC) $(FCFLAGS) $^ -o $@ $(LDFLAGS)

clean :
	rm -f persistant $(OBJS) core
