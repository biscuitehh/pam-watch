VERSION = 2
LIBRARY_NAME = pam_watchid.so
DESTINATION = /usr/local/lib/pam
TARGET := $(shell uname -m)-apple-darwin$(shell uname -r)

.PHONY: all

all: $(LIBRARY_NAME)

$(LIBRARY_NAME): watchid-pam-extension.swift
	swiftc watchid-pam-extension.swift -o $(LIBRARY_NAME) -target $(TARGET) -emit-library

install: $(LIBRARY_NAME)
	mkdir -p $(DESTINATION)
	install -b -o root -g wheel -m 444 $(LIBRARY_NAME) $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)

install-pam:
	grep $(LIBRARY_NAME) /etc/pam.d/sudo >/dev/null || echo auth sufficient $(LIBRARY_NAME) | cat - /etc/pam.d/sudo | sudo tee /etc/pam.d/sudo > /dev/null
	grep $(LIBRARY_NAME) /etc/pam.d/su >/dev/null || echo auth sufficient $(LIBRARY_NAME) | cat - /etc/pam.d/su | sudo tee /etc/pam.d/su > /dev/null