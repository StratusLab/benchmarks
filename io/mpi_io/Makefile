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

FCFLAGS += -DVAL_M=701 -DVAL_N=801



OBJS = o_at.o i_at.o io_at.o

all:	o_at i_at io_at

o_at : o_at.f90
	$(FC) $(FCFLAGS) $^ -o $@

i_at : i_at.f90
	$(FC) $(FCFLAGS) $^ -o $@
io_at :  io_at.f90
	$(FC) $(FCFLAGS) $^ -o $@
clean :
	rm -f i_at o_at  io_at $(OBJS) 
