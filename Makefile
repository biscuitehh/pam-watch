VERSION = 2
LIBRARY_NAME = pam_watchid.so
DESTINATION = /usr/local/lib/pam
TARGET = x86_64-apple-macosx10.15

all:
	swiftc watchid-pam-extension.swift -o $(LIBRARY_NAME) -target $(TARGET) -emit-library

install: all
	mkdir -p $(DESTINATION)
	cp $(LIBRARY_NAME) $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)
	chmod 444 $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)
	chown root:wheel $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)

install-pam:
	grep $(LIBRARY_NAME) /etc/pam.d/sudo >/dev/null || echo auth sufficient $(LIBRARY_NAME) | cat - /etc/pam.d/sudo | sudo tee /etc/pam.d/sudo > /dev/null
	grep $(LIBRARY_NAME) /etc/pam.d/su >/dev/null || echo auth sufficient $(LIBRARY_NAME) | cat - /etc/pam.d/su | sudo tee /etc/pam.d/su > /dev/null