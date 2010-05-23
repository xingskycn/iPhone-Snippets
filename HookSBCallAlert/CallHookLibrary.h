/*
 *  CallHookLibrary.h
 *  
 *  Modified by Alexander on 11/29/09.
 *  Created by John on 10/4/08.
 *  Copyright 2008 Gojohnnyboi. All rights reserved.
 *
 */

#import "CallHookProtocol.h"

// Our method to override the launch of the icon
static void __$CallHook_AppIcon_Launch(SBApplicationIcon<CallHook> *_SBApplicationIcon);

// Our intiialization point that will be called when the dylib is loaded
extern "C" void CallHookInitialize();
