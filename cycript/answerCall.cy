#!/usr/bin/cycript -p SpringBoard
var tm = [SBTelephonyManager sharedTelephonyManager]
if(tm.incomingCallExists) {
 [tm answerIncomingCall]
}

