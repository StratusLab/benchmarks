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




OBJS = asynchrone.o

all:	asynchrone

asynchrone : asynchrone.f90
	$(FC) $(FCFLAGS) $^ -o $@ $(LDFLAGS)

clean :
	rm -f asynchrone $(OBJS) core
