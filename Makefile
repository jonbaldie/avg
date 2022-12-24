build:
	rm -rf build && mkdir -p build && ghc -O2 Main.hs -o build/avg

clean:
	rm -f Main.hi Main.o

all:
	make build --always-make && make clean
