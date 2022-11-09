VERSION = 2
LIBRARY_NAME = pam_watchid.so
DESTINATION = /usr/local/lib/pam
TARGET = arm64

all:
	swiftc watchid-pam-extension.swift -o $(LIBRARY_NAME) -target $(TARGET) -emit-library

install: all
	mkdir -p $(DESTINATION)
	cp $(LIBRARY_NAME) $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)
	chmod 444 $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)
	chown root:wheel $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)
