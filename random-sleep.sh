#! /bin/sh
# A portable POSIX shell script for waiting random amounts of time.
# Requires `/dev/urandom` to provide random bytes.
# Copyright (c) 2024 D. Bohdan.
# License: MIT.
# See https://github.com/dbohdan/random-sleep
set -eu

me=$(basename "$0")
version=1.0.0

usage() {
    printf 'Usage: %s [-h] [-V] [-v] NUMBER[SUFFIX]\n' "$me"
}

help() {
    cat <<EOF

Sleep a random whole number of seconds between 0 and NUMBER seconds, minutes, or hours (inclusive).

Arguments:
  NUMBER[SUFFIX]
          The maximum sleep duration. NUMBER must be a non-negative integer. The optional SUFFIX must be 's', 'm', or 'h' when present. The suffix is case-insensitive.

Options:
  -h, --help
          Print this help message and exit.

  -V, --version
          Print the version number and exit.

  -v, --verbose
          Print the generated number of seconds to standard error before sleeping.

Setting the environment variable 'RANDOM_SLEEP_DEBUG' has the same effect as the option '-v'/'--verbose'.
EOF
}

# A portable random integer generator.
# The range must not exceed 2^32 - 1.
random_int() {
    _min=${1:-1}
    _max=${2:-100}
    _range=$((_max - _min + 1))

    if ! [ -r /dev/urandom ]; then
        printf "couldn't access /dev/urandom\n" >&2
        return 1
    fi

    # Use dd(1) to read four bytes, od(1) to convert them to decimal.
    # Remove whitespace and leading zeroes,
    # which some systems' shells reject in an arithmetic expression.
    _rand=$(dd if=/dev/urandom bs=4 count=1 2>/dev/null |
        od -A n -t u4 |
        sed 's|^ *0*||;s| *$||')
    printf '%d\n' $((_min + (_rand % _range)))
}

random_wait() {
    _max=$1
    _duration=$(random_int 0 "$_max")

    if [ "$verbose" -gt 0 ]; then
        printf '%d\n' "$_duration" >&2
    fi

    sleep "$_duration"
}

main() {
    # Process a help or version option in any position.
    # Help takes priority.
    for _arg in "$@"; do
        case "$_arg" in
        -\? | -h | --help | -help | help)
            usage
            help
            return 0
            ;;
        esac
    done

    for _arg in "$@"; do
        case "$_arg" in
        -V | --version)
            printf '%s\n' "$version"
            return
            ;;
        esac
    done

    # Process our one "regular" option.
    # Catch unrecognized options.
    verbose=0

    case "${1:-}" in
    -v | --verbose)
        verbose=1
        shift
        ;;
    -[0-9]*)
        printf 'negative numbers are not supported\n' >&2
        return 2
        ;;
    -*)
        printf 'unrecognized option: "%s"\n' "$1" >&2
        return 2
        ;;
    esac

    if [ "${RANDOM_SLEEP_DEBUG+set}" = set ]; then
        verbose=2
    fi

    # Check the positional argument count.
    if [ $# -eq 0 ]; then
        usage >&2
        return 2
    fi

    if [ $# -gt 1 ]; then
        printf 'too many arguments\n' >&2
        usage >&2
        return 2
    fi

    # Parse the positional argument.
    _arg="$1"
    if ! expr "$_arg" : '[0-9][0-9]*[HMShms]\{0,1\}$' >/dev/null; then
        printf 'invalid argument: "%s"\n' "$_arg" >&2
        usage >&2
        return 2
    fi

    _unit=$(expr "$_arg" : '[0-9][0-9]*\([HMShms]\{0,1\}\)' || true)
    _max=$(expr "$_arg" : '\([0-9][0-9]*\)' || true)

    case "$_unit" in
    [Mm])
        _max=$((_max * 60))
        ;;
    [Hh])
        _max=$((_max * 60 * 60))
        ;;
    esac

    random_wait "$_max"
}

main "$@"
