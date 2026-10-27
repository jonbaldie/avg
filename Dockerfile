FROM haskell:9.4.3

WORKDIR /app

COPY Main.hs Makefile ./
RUN make build \
    && mv ./build/avg /usr/local/bin/avg \
    && make clean

CMD ["/usr/local/bin/avg"]
