/*
 *  CallHookProtocol.h
 *  
 *
 *  Created by John on 10/4/08.
 *  Copyright 2008 Gojohnnyboi. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SpringBoard/SBApplicationIcon.h>
#import <objc/runtime.h>
#import "substrate.h"

// We import our headers, "SpringBoard" being the dumped headers placed in your include directory.

@protocol CallHook

// When we redirect the "launch" method, we will specify this prefix, which
// will allow us to call the original method if desired.
- (void)__OriginalMethodPrefix_launch;

@end
