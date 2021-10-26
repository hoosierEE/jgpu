LIBS = -lafcpu
LIB_PATHS = -L/opt/arrayfire/lib
INCLUDES = -I/opt/arrayfire/include
COMPILER_OPTIONS = -std=c11 -g
CC = gcc $(COMPILER_OPTIONS)

OUTFILE=a.out
clean:
	rm -f a.out
	rm -rf a.out.dSYM

all: main.c
	$(CC) main.c -o $(OUTFILE) $(INCLUDES) $(LIBS) $(LIB_PATHS)
	install_name_tool -change @rpath/libafcpu.3.dylib /opt/arrayfire/lib/libafcpu.3.dylib $(OUTFILE)

test: clean all
	./$(OUTFILE)
