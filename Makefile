VERSION         = 2
LIBRARY_NAME 	= pam_watchid.so
DESTINATION 	= /usr/local/lib/pam
TARGET_ARCH     = $(shell uname -m)
TARGET 			=

ifeq ($(TARGET_ARCH), arm64)
	TARGET= arm64-apple-macos11
endif

ifeq ($(TARGET_ARCH), x86_64)
	TARGET = x86_64-apple-macos10.12
endif

install:

ifeq ($(TARGET), )
	$(error Target $(TARGET) is not (yet) supported!)
endif

	$(info Building for $(TARGET_ARCH))
	swiftc watchid-pam-extension.swift -o $(LIBRARY_NAME) -target $(TARGET) -emit-library

	mkdir -p $(DESTINATION)
	cp $(LIBRARY_NAME) $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)
	chmod 444 $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)
	chown root:wheel $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)