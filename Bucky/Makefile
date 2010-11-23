TARGET		= Bucky

$(TARGET):	Bucky.o  gl2ps.o 
	c++ -g -o $(TARGET) Bucky.o  gl2ps.o  \
	 `sdl-config --libs` -lGL -lGLU -lm

Bucky.o:   
	c++ -g  -c Bucky.cpp `sdl-config --cflags`

gl2ps.o:
	cc -g -c gl2ps.c 

clean:
	rm -f $(TARGET) *.o  core
