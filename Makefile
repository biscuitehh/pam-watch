VERSION 		= 2
LIBRARY_NAME 	= pam_watchid.so
DESTINATION 	= /usr/local/lib/pam
TARGET_ARCH     = $(shell uname -m)

ifeq ($(TARGET_ARCH), arm64)
	TARGET_OK = OK
endif

ifeq ($(TARGET_ARCH), x86_64)
	TARGET_OK = OK
endif


install:

ifneq ($(TARGET_OK), OK)
	$(error Target $(TARGET_ARCH) is not (yet) supported!)
endif

	$(info Building for $(TARGET_ARCH))
	$(MAKE) $(TARGET_ARCH)

	mkdir -p $(DESTINATION)
	cp $(LIBRARY_NAME) $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)
	chmod 444 $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)
	chown root:wheel $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)

x86_64:
	swiftc watchid-pam-extension.swift -o $(LIBRARY_NAME) -target x86_64-apple-macos10.12 -emit-library

arm64:
	swiftc watchid-pam-extension.swift -o $(LIBRARY_NAME) -target arm64-apple-macos11 -emit-library
