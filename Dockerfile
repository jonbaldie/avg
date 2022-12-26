FROM haskell:9.4.3

WORKDIR /app

RUN apt-get update -yqq \
    && apt-get install git -yqq \
    && git clone https://github.com/jonbaldie/avg.git \
    && cd avg \
    && make build && make clean \
    && mv ./build/avg /usr/local/bin/ 

CMD ["/usr/local/bin/avg"]
