SUBDIRS = cpu_intensive  io-mpi   mpi-async  mpi-persistent  mpi-standard  mpi-sync  openmp-cg  openmp-jacobi  openmp-matrix  
TARGETS= target
all:
	mkdir -p target/bin; mkdir -p target/scripts   
	for i in $(SUBDIRS); do (cd $$i; make all; mv bin/* ../$(TARGETS)/bin); done
	for i in $(SUBDIRS); do (cd $$i; cp scripts/* ../$(TARGETS)/scripts); done
	cp workflows/scripts/* $(TARGETS)/scripts
clean:
	for i in $(SUBDIRS); do (cd $$i; make clean); done
