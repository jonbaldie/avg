build:
	rm -rf build && mkdir -p build && ghc -O2 Main.hs -o build/avg

test:
	chmod +x test_cli.sh && ./test_cli.sh

clean:
	rm -rf build && rm -f Main.hi Main.o

all:
	make build --always-make && make clean

.PHONY: all build clean test
