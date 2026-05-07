#!/bin/sh

set -eu

# Reuse an existing build when the caller already compiled the binary to avoid
# concurrent ghc writes to Main.o during local verification.
if [ ! -x ./build/avg ]; then
  make build >/dev/null
fi

assert_fails_with() {
  expected="$1"
  shift

  set +e
  output=$(./build/avg "$@" 2>&1)
  status=$?
  set -e

  if [ "$status" -eq 0 ]; then
    printf 'expected failure but command succeeded: ./build/avg %s\n' "$*"
    exit 1
  fi

  printf '%s' "$output" | grep -F "$expected" >/dev/null || {
    printf 'expected output to contain: %s\nactual output:\n%s\n' "$expected" "$output"
    exit 1
  }
}

assert_succeeds_with() {
  expected="$1"
  shift

  output=$(./build/avg "$@" 2>&1)
  printf '%s' "$output" | grep -F "$expected" >/dev/null || {
    printf 'expected output to contain: %s\nactual output:\n%s\n' "$expected" "$output"
    exit 1
  }
}

assert_fails_with "Usage: avg \"<command>\" <iterations>"
assert_fails_with "Invalid iteration count: nope" "true" "nope"
assert_fails_with "Iteration count must be a positive integer" "true" "0"
assert_fails_with "Iteration count must be a positive integer" "true" "-2"
assert_fails_with "Command failed with exit code 1" "false" "1"
assert_succeeds_with "Average elapsed time:" "true" "2"

printf 'test_cli.sh: all checks passed\n'
