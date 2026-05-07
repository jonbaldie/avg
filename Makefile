build:
	rm -rf build && mkdir -p build && ghc -O2 Main.hs -o build/avg

test: build
	printf '2\n4\n6\n' | build/avg "cat" 3 | grep -E '^Average elapsed time: [0-9.]+s$$'

clean:
	rm -f Main.hi Main.o

all:
	make build --always-make && make clean

.PHONY: all build clean test
