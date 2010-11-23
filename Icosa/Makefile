TARGET		= Icosa

$(TARGET):	Icosa.o  gl2ps.o 
	c++ -g -o $(TARGET) Icosa.o  gl2ps.o  \
	 `sdl-config --libs` -lGL -lGLU -lOGLFT  -lm

Icosa.o:   
	c++ -g  -c Icosa.cpp `sdl-config --cflags`

gl2ps.o:
	cc -g -c gl2ps.c 

clean:
	rm -f $(TARGET) *.o  core
