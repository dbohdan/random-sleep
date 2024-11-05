#! /bin/sh
# Smoke tests for random-sleep.
# Copyright (c) 2024 D. Bohdan.
# License: MIT.
# See https://github.com/dbohdan/random-sleep
set -eu

random_sleep=${RANDOM_SLEEP:-./random-sleep}

test_args() {
    _cond=$1
    shift

    if [ -z "$1" ]; then
        _print_args="'' $*"
    else
        _print_args=$*
    fi
    test_number=$((test_number + 1))
    printf '%2d  expect %-3s  %-6s' "$test_number" "$_cond" "$_print_args"

    case "$_cond" in
    err)
        if "$random_sleep" "$@" >/dev/null 2>&1; then
            printf '  failed'
            status=1
        fi
        ;;
    ok)
        if ! "$random_sleep" "$@" >/dev/null 2>&1; then
            printf '  failed'
            status=1
        fi
        ;;
    *)
        printf 'invalid condition: "%s"\n' "$_cond"
        return 1
        ;;
    esac

    printf '\n'
}

status=0
test_number=0

test_args err ''
test_args err 0ms
test_args err -1
test_args err -v
test_args err -x
test_args ok --help
test_args ok -V
test_args ok -v 0
test_args ok 0
test_args ok 0h
RANDOM_SLEEP_DEBUG='' test_args ok 2

exit "$status"
