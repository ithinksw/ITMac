/*
 *	ITMac
 *	ITMacResource.h
 *
 *	Class that wraps Carbon ResourceManager resources.
 *
 *	Copyright (c) 2005 by iThink Software.
 *	All Rights Reserved.
 *
 *	$Id$
 *
 */

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

typedef ResType ITMacResourceType;

@interface ITMacResource : NSObject {
	@protected
	Handle _handle;
}

+ (Class)subclassForType:(ITMacResourceType)type;

+ (NSArray *)supportedResourceTypes;
+ (BOOL)supportsResourceType:(ITMacResourceType)type;

+ (id)resourceWithHandle:(Handle)handle;
- (id)initWithHandle:(Handle)handle;

- (Handle)handle;

- (NSData *)data;
- (ITMacResourceType)type;
- (short)id;
- (NSString *)name;

- (Class)nativeRepresentationClass;
- (id)nativeRepresentation;

@end