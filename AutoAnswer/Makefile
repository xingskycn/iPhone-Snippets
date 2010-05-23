EXE = autoanswer
VERSION = 1.0

CODESIGN = ldid -S

# These paths must be changed to match the compilation environment
SYS_PATH = /var/toolchain/sys30
CC = arm-apple-darwin9-gcc
CFLAGS = -march=armv6 -mcpu=arm1176jzf-s -Wall -Os -ObjC -std=gnu99 -multiply_defined suppress
LD = $(CC)
LDFLAGS = -march=armv6 \
		  -mcpu=arm1176jzf-s \
		  -bind_at_load \
		  -multiply_defined suppress \
          -framework CoreFoundation \
          -framework CoreTelephony \
		  -framework Foundation \
		  -F$(SYS_PATH)/System/Library/PrivateFrameworks \
		  -F$(SYS_PATH)/System/Library/Frameworks \
		  -F/System/Library/PrivateFrameworks \
		  -F/System/Library/Frameworks \
          -lobjc \
	  -L$(SYS_PATH)/usr/lib/ \

INCLUDES = -F$(SYS_PATH)/System/Library/PrivateFrameworks

SRCS       := main.m
OBJS       := $(SRCS:.m=.o)

all: $(EXE)

$(EXE): $(OBJS) $(HDRS)
	$(LD) $(LDFLAGS) $(OBJS) -o $@
	$(CODESIGN) $(EXE)

%.o: %.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $(INCLUDES) $< -o $@
	   
clean:
	rm -f $(OBJS) $(EXE)

.PHONY: all clean
