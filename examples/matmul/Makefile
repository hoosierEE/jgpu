LIBNAME=afcpu
LIBS=-l$(LIBNAME)
LIB_PATHS=-L/home/alex/Downloads/arrayfire/lib64
INCLUDES=-I/home/alex/Downloads/arrayfire/include
# LIB_PATHS=-L/opt/arrayfire/lib
# INCLUDES=-I/opt/arrayfire/include
COMPILER_OPTIONS=-std=c++11 -g
CC=g++ $(COMPILER_OPTIONS)
EXE=matmul

# install_name_tool line added to fix runtime error on MacOS
all: main.cpp Makefile
	$(CC) main.cpp -o $(EXE) $(INCLUDES) $(LIBS) $(LIB_PATHS)
	# the following line fixes a weird runtime error
	# install_name_tool -change @rpath/lib${LIBNAME}.3.dylib /opt/arrayfire/lib/lib${LIBNAME}.3.dylib $(EXE)

clean:
	rm -f $(EXE)

test: clean all
	./$(EXE)

# /home/alex/downloads/arrayfire/
