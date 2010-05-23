//
//  CallHook.mm
//  CallHook
//
//  Created by Alexander Lash on 11/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//
//  MobileSubstrate, libsubstrate.dylib, and substrate.h are
//  created and copyrighted by Jay Freeman a.k.a saurik and 
//  are protected by various means of open source licensing.
//
//  Additional defines courtesy Lance Fetters a.k.a ashikase
//


#include <substrate.h>

#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBApplicationIcon.h>
#import <SpringBoard/SBCallAlert.h>
#import <SpringBoard/SBCallAlertDisplay.h>
#import <VoiceServices/VSSpeechSynthesizer.h>

//typedef struct __CTCall CTCall;
//typedef CTCall* CTCallRef;
//NSString *CTCallCopyAddress(CFAllocatorRef allocator, CTCallRef call);

typedef struct __CTCall CTCall;
extern NSString *CTCallCopyAddress(void*);

//(NSString)_CTCallCopyAddress:(struct __CTCall)call;
//(NSString)_CTCallCopyName:(struct __CTCall)call;

//(NSString)CTCallCopyAddress:(CFAllocatorRef)alloc,(CTCallRef)call;
//(NSString)CTCallCopyName:(CFAllocatorRef)alloc,(CTCallRef)call;

void say(NSString *string)
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	if (![string isEqualToString:@""]) {
		VSSpeechSynthesizer *speechSynth = [[VSSpeechSynthesizer alloc] init];
		[speechSynth startSpeakingString:string toURL:nil withLanguageCode:@"en-US"];
		while ([VSSpeechSynthesizer isSystemSpeaking])
			usleep(100);
	}
	
    [pool release];
}


#define HOOK(class, name, type, args...) \
static type (*_ ## class ## $ ## name)(class *self, SEL sel, ## args); \
static type $ ## class ## $ ## name(class *self, SEL sel, ## args)

#define CALL_ORIG(class, name, args...) \
_ ## class ## $ ## name(self, sel, ## args)





#pragma mark Hooked SpringBoard messages
#pragma mark 


HOOK(SpringBoard, applicationDidFinishLaunching$, void, UIApplication *app) {
    CALL_ORIG(SpringBoard, applicationDidFinishLaunching$, app);
	NSLog(@"Congratulations, you've hooked SpringBoard!");
}

HOOK(SBApplicationIcon, launch, void)
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	NSLog([self displayName]);
	say([self displayName]);
	[pool release];
	CALL_ORIG(SBApplicationIcon, launch);
	
}

HOOK(SBCallAlert, _handleCallerIDEvent, void, struct __CTCall *call)
{
	SBCallAlert me = *self;
	NSString *addr = CTCallCopyAddress(call);
	
	NSLog(@"Call received address: %@", addr);
	CALL_ORIG(SBCallAlert, _handleCallerIDEvent, call);
	
	addr = CTCallCopyAddress(call);
	NSLog(@"ORIG received address: %@", addr);
}

HOOK(SBCallAlertDisplay, updateLCDWithName, void, id *identity, id *label, unsigned int *breakPoint)
{
	NSLog(@"SBCallAlertDisplay updateLCDWithName intercepted");
	NSLog(@"identity: %s",identity);
	NSLog(@"label: %s", label);
	NSLog(@"BreakPoint: %d",breakPoint);
	CALL_ORIG(SBCallAlertDisplay, updateLCDWithName, identity, label, breakPoint);
}

static void callback_call(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
//    NSDictionary *info = (NSDictionary *)userInfo;
//    CTCall *call = (CTCall *)[info objectForKey:@"kCTCall"];
//    NSString caller = CTCallCopyAddress(NULL, call);
//    CTCallDisconnect(call);
    /* or one of the following functions: CTCallAnswer
	 CTCallAnswerEndingActive
	 CTCallAnswerEndingAllOthers
	 CTCallAnswerEndingHeld
	 */
}

#pragma mark dylib initialization and initial hooks
#pragma mark 

extern "C" void CallHookInitialize() {	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
		
    	
	//Check open application and create hooks here:
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    if ([identifier isEqualToString:@"com.apple.springboard"]) {
/*
		id ct = CTTelephonyCenterGetDefault();
        CTTelephonyCenterAddObserver(
									 ct, 
									 NULL, 
									 callback_call,
									 NULL,
									 NULL,
									 CFNotificationSuspensionBehaviorHold);
 */
		
/*		
		Class $SpringBoard(objc_getClass("SpringBoard"));
		_SpringBoard$applicationDidFinishLaunching$ = MSHookMessage($SpringBoard, @selector(applicationDidFinishLaunching:), &$SpringBoard$applicationDidFinishLaunching$);
		
		Class $SBApplicationIcon(objc_getClass("SBApplicationIcon"));
		_SBApplicationIcon$launch = MSHookMessage($SBApplicationIcon, @selector(launch), &$SBApplicationIcon$launch);
		
		Class $SBCallAlertDisplay(objc_getClass("SBCallAlertDisplay"));
		_SBCallAlertDisplay$updateLCDWithName = MSHookMessage($SBCallAlertDisplay, @selector(updateLCDWithName:), &$SBCallAlertDisplay$updateLCDWithName);
*/
		Class $SBCallAlert(objc_getClass("SBCallAlert"));
	    _SBCallAlert$_handleCallerIDEvent = MSHookMessage($SBCallAlert, @selector(_handleCallerIDEvent:), &$SBCallAlert$_handleCallerIDEvent);
		
	}
	
	
    [pool release];
}

