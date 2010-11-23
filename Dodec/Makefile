TARGET		= Dodec

$(TARGET):	Dodec.o  gl2ps.o 
	c++ -g -o $(TARGET) Dodec.o  gl2ps.o  \
	 `sdl-config --libs` -lGL -lGLU -lOGLFT  -lm

Dodec.o:   
	c++ -g  -c Dodec.cpp `sdl-config --cflags`

gl2ps.o:
	cc -g -c gl2ps.c 

clean:
	rm -f $(TARGET) *.o  core
