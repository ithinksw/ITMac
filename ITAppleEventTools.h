/*
 *	ITMac
 *	ITAppleEventTools.h
 *
 *	Functions to aid in sending raw AppleEvents.
 *
 *	Copyright (c) 2005 by iThink Software.
 *	All Rights Reserved.
 *
 *	$Id$
 *
 */

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

extern NSString *_ITAEDescCarbonDescription(AEDesc desc);

extern NSAppleEventDescriptor *ITSendAE(FourCharCode eClass, FourCharCode eID, const ProcessSerialNumber *psn);
extern NSAppleEventDescriptor *ITSendAEWithKey(FourCharCode reqKey, FourCharCode evClass, FourCharCode evID, const ProcessSerialNumber *psn);
extern NSAppleEventDescriptor *ITSendAEWithString(NSString *sendString, FourCharCode evClass, FourCharCode evID, const ProcessSerialNumber *psn);
extern NSAppleEventDescriptor *ITSendAEWithStringAndTimeout(NSString *sendString, FourCharCode evClass, FourCharCode evID, const ProcessSerialNumber *psn, long timeout);
extern NSAppleEventDescriptor *ITSendAEWithStringAndObject(NSString *sendString, const AEDesc *object, FourCharCode evClass, FourCharCode evID, const ProcessSerialNumber *psn);