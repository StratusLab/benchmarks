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





OBJS = write_at.o

all:	write_at

write_at : write_at.f90
	$(FC) $(FCFLAGS) $^ -o $@

clean :
	rm -f write_at$(OBJS) core
