# random-sleep

A portable POSIX shell script for waiting random amounts of time.
This is useful, for example, to prevent your cron jobs from all starting simultaneously, causing the [thundering herd problem](https://en.wikipedia.org/wiki/Thundering_herd_problem).

The script requires `/dev/urandom` to provide random bytes.
It has been tested on Alpine Linux, FreeBSD, macOS, NetBSD, OpenBSD, and Ubuntu.

## Installation

Run the following command in the repository to install `random-sleep` to `/usr/local/bin/` if you have sudo.

```shell
sudo make install
```

## Usage

```none
Usage: random-sleep [-h] [-V] [-v] NUMBER[SUFFIX]

Sleep a random whole number of seconds between 0 and NUMBER seconds, minutes,
or hours (inclusive).

Arguments:
  NUMBER[SUFFIX]
          The maximum sleep duration. NUMBER must be a non-negative integer.
The optional SUFFIX must be 's', 'm', or 'h' when present. The suffix is
case-insensitive.

Options:
  -h, --help
          Print this help message and exit.

  -V, --version
          Print the version number and exit.

  -v, --verbose
          Print the generated number of seconds to standard error before
sleeping.

Setting the environment variable 'RANDOM_SLEEP_DEBUG' has the same effect as
the option '-v'/'--verbose'.
```

## License

MIT.
See the file [`LICENSE`](LICENSE).
