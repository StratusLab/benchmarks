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





OBJS = Serveur.o Client.o

all:	Serveur Client

Client : Client.F90
	$(FC) $(FCFLAGS) $^ -o $@

Serveur : Serveur.F90
	$(FC) $(FCFLAGS) $^ -o $@
clean :
	rm -f Serveur Client $(OBJS) core
