/*
 *	ITMac
 *	ITOSAScript.h
 *
 *	Class that wraps OpenScripting scripts.
 *
 *	Copyright (c) 2005 iThink Software
 *
 */

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@class ITOSAComponent;

@interface ITOSAScript : NSObject {
	NSString *_source;
	ITOSAComponent *_component;
	OSAID _scriptID;
}

- (id)initWithContentsOfFile:(NSString *)path;
- (id)initWithSource:(NSString *)source;

- (NSString *)source;

- (ITOSAComponent *)component;
- (void)setComponent:(ITOSAComponent *)newComponent;

- (BOOL)compileAndReturnError:(NSDictionary **)errorInfo;
- (BOOL)isCompiled;

- (NSAppleEventDescriptor *)executeAndReturnError:(NSDictionary **)errorInfo;

@end