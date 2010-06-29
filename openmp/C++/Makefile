CC = gcc -fopenmp
CXX = gcc -fopenmp
CCC = gcc -fopenmp
F77 = 
FC = 


CFLAGS = -g
CXXFLAGS = -g
CCFLAGS = -g
F77FLAGS = -g
FCFLAGS = -g



all: Test

clean:
	rm -f *~ *.o Test


Test: Test.c
	$(CC) $(CFLAGS) $^ -o $@

