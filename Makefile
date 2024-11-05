DESTDIR=
PREFIX=/usr/local
BINDIR=$(PREFIX)/bin

.PHONY: test
test:
	./test.sh

# Lint with ShellCheck.
.PHONY: check
check:
	shellcheck ./*.sh

# Format the source code with https://github.com/mvdan/sh
.PHONY: format
format:
	shfmt -i 4 -w ./*.sh

.PHONY: install
install:
	mkdir -p $(DESTDIR)$(BINDIR)
	install random-sleep $(DESTDIR)$(BINDIR)

.PHONY: uninstall
uninstall:
	rm $(DESTDIR)$(BINDIR)/random-sleep
