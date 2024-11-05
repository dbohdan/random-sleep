# random-sleep

A portable POSIX shell script for waiting random amounts of time.
This is useful, for example, to prevent your cron jobs from all starting at the same time, causing the [thundering herd problem](https://en.wikipedia.org/wiki/Thundering_herd_problem).

The script requires `/dev/urandom` to provide random bytes.
It has been tested on Alpine Linux, FreeBSD, macOS, NetBSD, OpenBSD, and Ubuntu.

## Installation

Run the following command in the repository to install `random-sleep` to `/usr/local/bin/`.

```shell
sudo make install
```

## Usage

```none
usage: random-sleep [-v|--verbose] NUMBER[SUFFIX]

Sleep a random whole number of seconds between 0 and NUMBER seconds, minutes,
or hours (inclusive).

NUMBER must be a non-negative integer.
The optional SUFFIX must be "s", "m", or "h" when present (case-insensitive).

Pass the option "-v"/"--verbose" or set the environment variable
"RANDOM_SLEEP_DEBUG" to print the generated number of seconds to standard error.
```

## License

MIT.
See the file [`LICENSE`](LICENSE).
