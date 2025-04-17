TARGET=program
cc=gcc
cflags=-Wall -g

all: $(TARGET)
	./$(TARGET) 

$(TARGET): ./prog.o
	$(cc) $(cflags) -o $@ $^

prog.c: ./prog.math
	./mathlang < prog.math > prog.c

prog.o: ./prog.c
	$(cc) $(cflags) -c $< -o $@

clean:
	rm -f *.o

