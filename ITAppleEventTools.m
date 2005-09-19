#import "ITAppleEventTools.h"
#import <ITFoundation/ITCarbonSupport.h>

NSString *_ITAEDescCarbonDescription(AEDesc desc) {
	Handle descHandle;
	NSString *carbonDescription;
	AEPrintDescToHandle(&desc,&descHandle);
	carbonDescription = [NSString stringWithUTF8String:*descHandle];
	DisposeHandle(descHandle);
	return carbonDescription;
}

NSAppleEventDescriptor *ITSendAE(FourCharCode eClass, FourCharCode eID, const ProcessSerialNumber *psn) {
	AEDesc dest;
	int pid;
	AppleEvent event, reply;
	OSStatus cerr, err;
	NSAppleEventDescriptor *cocoaReply;
	
	if ((GetProcessPID(psn, &pid) == noErr) && (pid == 0)) {
		ITDebugLog(@"ITSendAE(%@, %@, {%i, %i}): Error getting PID of application.", NSStringFromFourCharCode(eClass), NSStringFromFourCharCode(eID), psn->highLongOfPSN, psn->lowLongOfPSN);
		return nil;
	}
	
	AECreateDesc(typeProcessSerialNumber, psn,sizeof(ProcessSerialNumber),&dest);
	cerr = AECreateAppleEvent(eClass,eID,&dest,kAutoGenerateReturnID,kAnyTransactionID,&event);
	
	if (cerr) {
		return nil;
	}
	
	err = AESend(&event, &reply, kAENoReply, kAENormalPriority, /*kAEDefaultTimeout*/60, NULL, NULL);
	AEDisposeDesc(&dest);
	AEDisposeDesc(&event);
	
	if (err) {
		AEDisposeDesc(&reply);
		return nil;
	}
	return [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&reply] autorelease];
}

NSAppleEventDescriptor *ITSendAEWithKey(FourCharCode reqKey, FourCharCode evClass, FourCharCode evID, const ProcessSerialNumber *psn) {
	return ITSendAEWithString([NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%@'), from:'null'() }", NSStringFromFourCharCode(reqKey)], evClass, evID, psn);
}

NSAppleEventDescriptor *ITSendAEWithString(NSString *sendString, FourCharCode evClass, FourCharCode evID, const ProcessSerialNumber *psn) {
	pid_t pid;
	AppleEvent sendEvent, replyEvent;
	AEDesc resultDesc;
	DescType resultType;
	Size resultSize;
	
	AEBuildError buildError;
	OSStatus berr,err;
	
	if ((GetProcessPID(psn, &pid) == noErr) && (pid == 0)) {
		ITDebugLog(@"ITSendAEWithString(%@, %@, %@, {%i, %i}): Error getting PID of application.", sendString, NSStringFromFourCharCode(evClass), NSStringFromFourCharCode(evID), psn->highLongOfPSN, psn->lowLongOfPSN);
		return nil;
	}
	
	berr = AEBuildAppleEvent(evClass, evID, typeProcessSerialNumber,psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, [sendString UTF8String]);
	
	if (berr) {
		ITDebugLog(@"ITSendAEWithString(%@, %@, %@, {%i, %i}): Build Error: %d:%d at \"%@\"", sendString, NSStringFromFourCharCode(evClass), NSStringFromFourCharCode(evID), psn->highLongOfPSN, psn->lowLongOfPSN, (int)buildError.fError, buildError.fErrorPos, [sendString substringToIndex:buildError.fErrorPos]);
		return nil;
	}
	
	err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, /*kAEDefaultTimeout*/60, NULL, NULL);
	AEDisposeDesc(&sendEvent);
	
	if (err) {
		ITDebugLog(@"ITSendAEWithString(%@, %@, %@, {%i, %i}): Send Error: %i", sendString, NSStringFromFourCharCode(evClass), NSStringFromFourCharCode(evID), psn->highLongOfPSN, psn->lowLongOfPSN, err);
		return nil;
	}
	
	err = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);
	
	if (resultSize == 0 || err != 0) {
		AEDisposeDesc(&replyEvent);
		return nil;
	}
	
	AEGetParamDesc(&replyEvent, keyDirectObject, resultType, &resultDesc);
	AEDisposeDesc(&replyEvent);
	return [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&resultDesc] autorelease];
}

NSAppleEventDescriptor *ITSendAEWithStringAndObject(NSString *sendString, const AEDesc *object, FourCharCode evClass, FourCharCode evID, const ProcessSerialNumber *psn) {
	pid_t pid;
	AppleEvent sendEvent, replyEvent;
	NSAppleEventDescriptor *recv;
	AEDesc resultDesc;
	DescType resultType;
	Size resultSize;
	
	AEBuildError buildError;
	OSStatus berr,err;
	
	if ((GetProcessPID(psn, &pid) == noErr) && (pid == 0)) {
		ITDebugLog(@"ITSendAEWithStringAndObject(%@, <%@>, %@, %@, {%i, %i}): Error getting PID of application.", sendString, _ITAEDescCarbonDescription(*object), NSStringFromFourCharCode(evClass), NSStringFromFourCharCode(evID), psn->highLongOfPSN, psn->lowLongOfPSN);
		return nil;
	}
	
	berr = AEBuildAppleEvent(evClass, evID, typeProcessSerialNumber,psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, [sendString UTF8String]);
	
	if (berr) {
		ITDebugLog(@"ITSendAEWithStringAndObject(%@, <%@>, %@, %@, {%i, %i}): Build Error: %d:%d at \"%@\"", sendString, _ITAEDescCarbonDescription(*object), NSStringFromFourCharCode(evClass), NSStringFromFourCharCode(evID), psn->highLongOfPSN, psn->lowLongOfPSN, (int)buildError.fError, buildError.fErrorPos, [sendString substringToIndex:buildError.fErrorPos]);
		return nil;
	}
	
	AEPutParamDesc(&sendEvent, keyDirectObject, object);
	
	err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, /*kAEDefaultTimeout*/60, NULL, NULL);
	AEDisposeDesc(&sendEvent);
	
	if (err) {
		ITDebugLog(@"ITSendAEWithStringAndObject(%@, <%@>, %@, %@, {%i, %i}): Send Error: %i", sendString, _ITAEDescCarbonDescription(*object), NSStringFromFourCharCode(evClass), NSStringFromFourCharCode(evID), psn->highLongOfPSN, psn->lowLongOfPSN, err);
		return nil;
	}
	
	err = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);
	
	if (resultSize == 0 || err != 0) {
		AEDisposeDesc(&replyEvent);
		return nil;
	}
	
	AEGetParamDesc(&replyEvent, keyDirectObject, resultType, &resultDesc);
	AEDisposeDesc(&replyEvent);
	return [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&resultDesc] autorelease];
}