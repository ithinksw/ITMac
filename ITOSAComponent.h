/*
 *	ITMac
 *	ITOSAComponent.h
 *
 *	Class that wraps OpenScripting components.
 *
 *	Copyright (c) 2005 by iThink Software.
 *	All Rights Reserved.
 *
 *	$Id$
 *
 */

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@interface ITOSAComponent : NSObject {
	Component _component;
	ComponentInstance _componentInstance;
	NSDictionary *_information;
}

+ (ITOSAComponent *)appleScriptComponent;
+ (ITOSAComponent *)componentWithCarbonComponent:(Component)component;
+ (NSArray *)availableComponents;

- (id)initWithSubtype:(unsigned long)subtype;
- (id)initWithComponent:(Component)component;

- (Component)component;
- (ComponentInstance)componentInstance;
- (NSDictionary *)information;

@end