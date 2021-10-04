LIBNAME=afcpu
LIBS=-l$(LIBNAME)
LIB_PATHS=-L/opt/arrayfire/lib
INCLUDES=-I/opt/arrayfire/include
CC=g++ $(COMPILER_OPTIONS)
COMPILER_OPTIONS=-std=c++11 -g
EXE = matmul

all: main.cpp Makefile
	$(CC) main.cpp -o $(EXE) $(INCLUDES) $(LIBS) $(LIB_PATHS)
	# the following line fixes a weird runtime error
	install_name_tool -change @rpath/lib${LIBNAME}.3.dylib /opt/arrayfire/lib/lib${LIBNAME}.3.dylib $(EXE)

clean:
	rm -f $(EXE)

test: clean all
	./$(EXE)
