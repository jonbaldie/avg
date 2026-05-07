# avg

`avg` measures the average duration of a shell command across multiple runs.

[![CI](https://github.com/jonbaldie/avg/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/jonbaldie/avg/actions/workflows/ci.yml)

## Usage

Run `avg` with exactly two arguments: a single quoted command string and a positive integer iteration count.

```bash
avg "curl -o /dev/null https://example.com" 5
```

This runs the command five times and prints the average elapsed time:

```text
Average elapsed time: 0.1610317872s
```

Quoting matters: `avg` passes the command string to the shell, so commands containing spaces, flags, pipes, or redirects must stay inside the quoted first argument.

### Failure behavior

Invalid invocation fails fast with a helpful message:

```bash
avg
# Usage: avg "<command>" <iterations>

avg "true" nope
# Invalid iteration count: nope

avg "true" 0
# Iteration count must be a positive integer
```

If the measured command exits non-zero, `avg` also exits non-zero instead of printing a misleading average:

```bash
avg "false" 1
# Command failed with exit code 1
```

## Build And Install

GitHub Actions currently validates this repository with `ghc 9.4.3` in `.github/workflows/ci.yml`. That is the only CI-validated compiler version today.

In local investigation on macOS, `ghc 9.12.1` showed intermittent failures during repeated clean builds in this repository. Until a safe fix is verified, treat that combination as unstable rather than supported.

Build from source with `ghc` installed:

```bash
git clone https://github.com/jonbaldie/avg.git
cd avg
make build
mv -f ./build/avg /usr/local/bin/avg
```

Use `make clean` to remove local build artifacts when you are done:

```bash
make clean
```

`make all` is a build-and-clean convenience target for CI-style checks. It does not leave `./build/avg` behind, so it is not the right install step.

You can also run the published Docker image:

```bash
docker run --rm jonbaldie/avg avg "curl -o /dev/null https://example.com" 5
```

## Test Workflow

For a local single-build verification pass, start clean and run:

```bash
make clean
make build
./build/avg "true" 2
./test_cli.sh
make clean
```

This keeps the manual smoke test and the CLI regression script on the same built binary while mirroring the repo's normal quality gates.

Run the full non-interactive CLI regression suite with:

```bash
make test
```

Today that target builds the binary and executes `./test_cli.sh`, which verifies:

- missing arguments report usage
- malformed iteration counts fail clearly
- zero and negative iteration counts are rejected
- child command failures propagate as non-zero exits
- successful commands print `Average elapsed time:`

GitHub Actions runs `make build`, `make test`, and `make clean` with `ghc 9.4.3`, as defined in `.github/workflows/ci.yml`.
