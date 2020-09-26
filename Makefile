all: directories demo scanf sin file image_write circle

circle: circle.o
	ld ./build/circle.o -e _main -o ./build/circle -lc

circle.o: circle.s
	as -g -arch x86_64 circle.s -o ./build/circle.o

image_write: image_write.o
	ld ./build/image_write.o -e _main -o ./build/image_write -lc

image_write.o: image_write.s
	as -arch x86_64 image_write.s -o ./build/image_write.o

file: file.o
	ld ./build/file.o -e _main -o ./build/file -lc

file.o: file.s
	as -arch x86_64 file.s -o ./build/file.o

sin: sin.o
	ld ./build/sin.o -e _main -o ./build/sin -lc

sin.o: sin.s
	as -arch x86_64 sin.s -o ./build/sin.o

scanf: scanf.o
	ld ./build/scanf.o -e _main -o ./build/scanf -lc

scanf.o: scanf.s
	as -arch x86_64 scanf.s -o ./build/scanf.o

demo: demo.o
	ld ./build/demo.o -e _main -o ./build/demo -lc

demo.o: demo.s
	as -arch x86_64 demo.s -o ./build/demo.o

directories: build

build:
	mkdir -p build

clean:
	rm *.o demo scanf sin file image_write circle
	rm -rf build
