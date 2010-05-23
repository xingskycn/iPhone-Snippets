Compiler=arm-apple-darwin9-g++
IP=root@192.168.1.102
Sysroot=/var/toolchain/sys30

LDFLAGS=	-lobjc \
				-framework Foundation \
				-framework UIKit \
				-framework CoreFoundation \
				-framework VoiceServices \
				-framework CoreTelephony \
				-multiply_defined suppress \
				-L$(Sysroot)/usr/lib \
				-F$(Sysroot)/System/Library/Frameworks \
				-F$(Sysroot)/System/Library/PrivateFrameworks \
				-F/System/Library/Frameworks \
				-F/System/Library/PrivateFrameworks \
				-dynamiclib \
				-init _CallHookInitialize \
				-Wall \
				-Werror \
				-lsubstrate \
				-lobjc \
				-ObjC++ \
				-fobjc-exceptions \
				-march=armv6 \
				-mcpu=arm1176jzf-s \
				-fobjc-call-cxx-cdtors

CFLAGS= -dynamiclib \
				-I$(Sysroot)/usr/include \
				-I$(Sysroot)/dump

Objects=CallHookLibrary.o

Target=CallHook.dylib

all:	$(Target) install

install:
		chmod 755 $(Target)
		mv $(Target) /Library/MobileSubstrate/DynamicLibraries
		respring

uninstall:
		rm /Library/MobileSubstrate/DynamicLibraries/$(Target)
		respring

remote_install:
		scp $(Target) $(IP):/var/root
		ssh $(IP) chmod 755 $(Target) 
		ssh $(IP) mv $(Target) /Library/MobileSubstrate/DynamicLibraries
		ssh $(IP) killall SpringBoard

$(Target):	$(Objects)
		$(Compiler) $(LDFLAGS) -o $@ $^
		ldid -S $(Target)

%.o:	%.mm
		$(Compiler) -c $(CFLAGS) $< -o $@

clean:
		rm -f *.o $(Target)
