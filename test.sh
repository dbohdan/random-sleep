#! /bin/sh
# Smoke tests for random-sleep.
# Copyright (c) 2024 D. Bohdan.
# License: MIT.
# See https://github.com/dbohdan/random-sleep
set -eu

random_sleep=${RANDOM_SLEEP:-./random-sleep}

test_arg() {
    _cond=$1
    _arg=$2

    _print_arg=$_arg
    if [ -z "$_print_arg" ]; then
        _print_arg="''"
    fi
    printf 'testing %-3s %s\n' "$_cond" "$_print_arg"

    case "$_cond" in
    err)
        if "$random_sleep" "$_arg" >/dev/null 2>&1; then
            printf 'test failed\n'
            status=1
        fi
        ;;
    ok)
        if ! "$random_sleep" "$_arg" >/dev/null 2>&1; then
            printf 'test failed\n'
            status=1
        fi
        ;;
    *)
        printf 'invalid condition: "%s"\n' "$_cond"
        exit 1
        ;;
    esac
}

status=0

test_arg err ''
test_arg err 0ms
test_arg ok --help
test_arg ok 0
test_arg ok 0h
RANDOM_SLEEP_DEBUG='' test_arg ok 2

exit "$status"
