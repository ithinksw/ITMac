/*
 *	ITMac
 *	ITMacResourceFile.h
 *
 *	Class that wraps Carbon ResourceManager resource files.
 *
 *	Copyright (c) 2005 by iThink Software.
 *	All Rights Reserved.
 *
 *	$Id$
 *
 */

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import <ITMac/ITMacResource.h>

@interface ITMacResourceFile : NSObject {
	FSRef _fileReference;
	SInt16 _referenceNumber;
}

+ (HFSUniStr255)dataForkName;
+ (HFSUniStr255)resourceForkName;

- (id)initWithContentsOfFile:(NSString *)path;
- (id)initWithContentsOfFile:(NSString *)path fork:(HFSUniStr255)namedFork;

- (ITMacResource *)resourceOfType:(ITMacResourceType)type withID:(short)idNum;
- (ITMacResource *)resourceOfType:(ITMacResourceType)type withName:(NSString *)name;

@end