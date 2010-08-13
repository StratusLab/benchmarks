CC = gcc
CFLAGS = -g -O2


all: cpu_intensive

cpu_intensive: cpu_intensive.c
	mkdir -p bin 
	$(CC)  -o bin/$@ $^
clean:
	rm -rf bin *.o 
