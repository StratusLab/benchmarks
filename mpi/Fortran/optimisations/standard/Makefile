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




OBJS = standard.o

all:	standard

standard : standard.f90
	$(FC) $(FCFLAGS) $^ -o $@ $(LDFLAGS)

clean :
	rm -f standard $(OBJS) core
