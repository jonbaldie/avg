# avg

This is a tool for measuring the average duration of your console commands.

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/jonbaldie/avg/tree/main.svg?style=shield)](https://dl.circleci.com/status-badge/redirect/gh/jonbaldie/avg/tree/main)

## Usage

Pass in two arguments: your console command and then the number of iterations. 

```bash
./avg "curl -o /dev/null http://example.com" 5
```

This runs your `curl` command five times and returns the average time elapsed in seconds:

```
Average elapsed time: 0.1610317872s
```

## Installation

To build from sources:

```bash
git clone https://github.com/jonbaldie/avg.git && cd avg && make all && mv ./build/avg /usr/local/bin/
```

## Roadmap

- [x] CI config.yml file
- [x] CI workflow created
- [ ] Flesh out `make test`
- [ ] First GH release
- [ ] Installation docs

