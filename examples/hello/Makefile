LIBS=-lafcpu
LIB_PATHS=-L/opt/arrayfire/lib
INCLUDES=-I/opt/arrayfire/include
CC=g++ $(COMPILER_OPTIONS)
COMPILER_OPTIONS=-std=c++11 -g

all: main.cpp Makefile
	$(CC) main.cpp -o test $(INCLUDES) $(LIBS) $(LIB_PATHS)
