build:
	mkdir -p build && ghc -O2 Main.hs -o build/avg

clean:
	rm -f Main.hi Main.o
