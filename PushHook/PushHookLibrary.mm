//
//  PushHook.mm
//  PushHook
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
#import <SpringBoard/SBRemoteNotificationServer.h>
#import <SpringBoard/SBApplicationIcon.h>
#import <SpringBoard/SBCallAlert.h>
#import <SpringBoard/SBCallAlertDisplay.h>
#import <VoiceServices/VSSpeechSynthesizer.h>

#define HOOK(class, name, type, args...) \
static type (*_ ## class ## $ ## name)(class *self, SEL sel, ## args); \
static type $ ## class ## $ ## name(class *self, SEL sel, ## args)

#define CALL_ORIG(class, name, args...) \
_ ## class ## $ ## name(self, sel, ## args)

static IMP old_SBRemoteNotificationAlert_initWithApplication_body_showActionButton_actionLabel = NULL;
static id replaced_SBRemoteNotificationAlert_initWithApplication_body_showActionButton_actionLabel(id self, SEL _cmd, SBApplication* app, NSString* body, BOOL showActionButton, NSString* actionLabel) {
        // Check if the extension is enabled. If no, revert to default behavior.
/*        if ([bridge enabledForName:@"Push Notification Alert"]) {
               
                [app retain];
               
                NSString* appName = [app displayName];
                NSString* title2;
               
                if (showActionButton)
                        title2 = [NSString stringWithFormat:vinn, (actionLabel ?: view), appName];
                else
                        title2 = [NSString stringWithFormat:notifies, appName];
               
                GriPPushNotificationDelegate* delegate = (GriPPushNotificationDelegate*)bridge.growlDelegate;
                NSNumber* context = [delegate addApp:app];
                NSString* actualBody = [delegate prependBody:body forAppNumber:context];
                               
                [bridge notifyWithTitle:[push stringByAppendingString:title2]
                                        description:actualBody
                           notificationName:@"Push Notification Alert"
                                           iconData:[app displayIdentifier]
                                           priority:0
                                           isSticky:NO
                                   clickContext:context
                                         identifier:app.displayIdentifier];
               
                [self release];
                return [FakeAlert sharedAlert];
               
        } else */
    if(showActionButton) {
        NSLog(@"Recieved alert from %@ with text %@ with action %@", [app displayName], body, actionLabel);
    char plist[] = "{aps={badge=5;alert=hi;};etc=foo;}";
    NSDictionary* userInfo = [NSPropertyListSerialization propertyListFromData:[NSData dataWithBytesNoCopy:plist length:sizeof(plist) freeWhenDone:NO]
                                                          mutabilityOption:NSPropertyListImmutable format:nil errorDescription:nil];
    [[SBRemoteNotificationServer sharedInstance] connection:nil didReceiveMessageForTopic:@"com.seankovacs.gvmobile" userInfo:userInfo];
    }
    else
    {
        NSLog(@"Received alert from %@ with text %@", [app displayName], body);
    }
    return old_SBRemoteNotificationAlert_initWithApplication_body_showActionButton_actionLabel(self, _cmd, app, body, showActionButton, actionLabel);
}




static void terminator() {
//        [push release];
//        [notifies release];
//        [vinn release];
//        [view release];
}

extern "C" void PushHookInitialize() {
        atexit(&terminator);
       
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

//        NSURL* myDictURL = [NSURL fileURLWithPath:@"/Library/MobileSubstrate/DynamicLibraries/GriPPushNotification.plist" isDirectory:NO];
//        NSDictionary* localizationStrings = GPPropertyListCopyLocalizableStringsDictionary(myDictURL);

//        push = [([localizationStrings objectForKey:@"Push"] ?: @"[Push] ") retain];
//        notifies = [([localizationStrings objectForKey:@"%@ notifies"] ?: @"%@ notifies") retain];
//        vinn = [([localizationStrings objectForKey:@"%@ in %@"] ?: @"%@ in %@") retain];
//        view = [[[NSBundle mainBundle] localizedStringForKey:@"VIEW" value:@"View" table:@"SpringBoard"] retain];
       
        id cls = objc_getClass("SBRemoteNotificationAlert");
       
        old_SBRemoteNotificationAlert_initWithApplication_body_showActionButton_actionLabel
        = MSHookMessage(cls, @selector(initWithApplication:body:showActionButton:actionLabel:),
                                        (IMP)&replaced_SBRemoteNotificationAlert_initWithApplication_body_showActionButton_actionLabel, NULL);

//        SBRemoteNotificationAlert_activateApplication = [cls instanceMethodForSelector:@selector(activateApplication)];
 //       SBAlertItem_dismiss = [(Class)objc_getClass("SBAlertItem") instanceMethodForSelector:@selector(dismiss)];
       
        [pool drain];
}
