EXES=bonnie++ zcav

all: $(EXES)


#MORE_WARNINGS=-Weffc++ -Wcast-align
WFLAGS=-Wall -W -Wshadow -Wpointer-arith -Wwrite-strings -pedantic -ffor-scope $(MORE_WARNINGS)
CFLAGS=-O2  -DNDEBUG $(WFLAGS) $(MORECFLAGS)
CXX=g++ $(CFLAGS)


BONSRC=bon_io.cpp bon_file.cpp bon_time.cpp semaphore.cpp forkit.cpp \
 bon_suid.cpp
BONOBJS=$(BONSRC:.cpp=.o)


ZCAVSRC=bon_suid.cpp
ZCAVOBJS=$(ZCAVSRC:.cpp=.o)

ALLOBJS=$(BONOBJS) $(ZCAVOBJS)

bonnie++: bonnie++.cpp $(BONOBJS)
	$(CXX) bonnie++.cpp -o bonnie++ $(BONOBJS) $(LFLAGS)

zcav: zcav.cpp $(ZCAVOBJS)
	$(CXX) zcav.cpp -o zcav $(ZCAVOBJS) $(LFLAGS)

%.o: %.cpp %.h bonnie.h port.h
	$(CXX) -c $<

bon_suid.o: bon_suid.cpp bonnie.h port.h
	$(CXX) -c $<

clean:
	rm -f $(EXES) $(ALLOBJS) 

