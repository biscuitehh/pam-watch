VERSION 		= 2
LIBRARY_NAME 	= pam_watchid.so
DESTINATION 	= /usr/local/lib/pam
TARGET_ARCH	 	= $(shell uname -m)


.PHONY: x86 arm64

install:
	$(MAKE) clean

	$(info Building for $(TARGET_ARCH))
	$(MAKE) ${TARGET_ARCH}

	mkdir -p $(DESTINATION)
	cp $(LIBRARY_NAME) $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)
	chmod 444 $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)
	chown root:wheel $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)

x86:
	swiftc watchid-pam-extension.swift -o $(LIBRARY_NAME) -target x86_64-apple-macos10.12 -emit-library

arm64:
	swiftc watchid-pam-extension.swift -o $(LIBRARY_NAME) -target arm64-apple-macos11 -emit-library

clean:
	rm *.so