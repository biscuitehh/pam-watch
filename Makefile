VERSION         = 2
LIBRARY_NAME 	= pam_watchid.so
DESTINATION 	= /usr/local/lib/pam
TARGET_ARCH     = $(shell uname -m)
TARGET 			=
.DEFAULT_GOAL   = build



ifeq ($(TARGET_ARCH), arm64)
	BUILD_VERS = $(shell sw_vers -productVersion | awk -F. 'BEGIN { OFS="." } { print $$1 }' )
	TARGET = arm64-apple-macos13
endif

ifeq ($(TARGET_ARCH), x86_64)
	BUILD_VERS = $(shell sw_vers -productVersion | awk -F. 'BEGIN { OFS="." } { print $$1,$$2 }' )
	TARGET = "x86_64-apple-macos$(BUILD_VERS)"
endif

build:
ifeq ($(TARGET), )
	$(error Target $(TARGET) is not (yet) supported!)
endif
	$(info Build version is $(BUILD_VERS))
	$(info Building for $(TARGET_ARCH))
	swiftc -v watchid-pam-extension.swift -o $(LIBRARY_NAME) -target $(TARGET) -emit-library

install:
	mkdir -p $(DESTINATION)
	cp $(LIBRARY_NAME) $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)
	chmod 444 $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)
	chown root:wheel $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)