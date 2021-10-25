LIBS=-lafcpu
LIB_PATHS=-L/opt/arrayfire/lib
INCLUDES=-I/opt/arrayfire/include
CC=g++ $(COMPILER_OPTIONS)
COMPILER_OPTIONS=-std=c++11 -g

all: main.cpp Makefile
	$(CC) main.cpp -o test $(INCLUDES) $(LIBS) $(LIB_PATHS)

LIBS=-lafcpu
LIB_PATHS=-L/opt/arrayfire/lib
INCLUDES=-I/opt/arrayfire/include
CC=g++ $(COMPILER_OPTIONS)
COMPILER_OPTIONS=-std=c++11 -g

OUTFILE=a.out

all: main.cpp Makefile
	$(CC) main.cpp -o $(OUTFILE) $(INCLUDES) $(LIBS) $(LIB_PATHS)
	install_name_tool -change @rpath/libafcpu.3.dylib /opt/arrayfire/lib/libafcpu.3.dylib $(OUTFILE)

test: all
	./$(OUTFILE)
