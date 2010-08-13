SUBDIRS = cpu_intensive io-bonnie++  io-mpi   mpi-async  mpi-persistent  mpi-standard  mpi-sync  openmp-cg  openmp-jacobi  openmp-matrix 
TARGETS= target
all: 
	for i in $(SUBDIRS); do (cd $$i; make all; mv bin/* ../$(TARGETS)/bin); done
	for i in $(SUBDIRS); do (cd $$i; cp *.sh ../$(TARGETS)/scripts); done
clean:
	for i in $(SUBDIRS); do (cd $$i; make clean); done
