#import "ITMacResource.h"

@implementation ITMacResource

+ (Class)subclassForType:(ITMacResourceType)type {
	NSEnumerator *subclassEnumerator = [[self subclasses] objectEnumerator];
	Class subclass;
	
	while ((subclass = [subclassEnumerator nextObject])) {
		if ([subclass supportsResourceType:type]) {
			return subclass;
		}
	}
	
	return self;
}

+ (NSArray *)supportedResourceTypes {
	return [NSArray array];
}

+ (BOOL)supportsResourceType:(ITMacResourceType)type {
	return [[self supportedResourceTypes] containsObject:[NSString stringWithFourCharCode:type]];
}

+ (id)resourceWithHandle:(Handle)handle {
	return [[[self alloc] initWithHandle:handle] autorelease];
}

- (id)initWithHandle:(Handle)handle {
	if (self = [super init]) {
		_handle = handle;
	}
	return self;
}

- (Handle)handle {
	return _handle;
}

- (NSData *)data {
	NSData *_data;
	HLock(_handle);
	_data = [NSData dataWithBytes:(*_handle) length:GetHandleSize(_handle)];
	HUnlock(_handle);
	return _data;
}

- (ITMacResourceType)type {
	short _id;
	ResType _type;
	Str255 _name;
	GetResInfo(_handle, &_id, &_type, _name);
	return (ITMacResourceType)_type;
}

- (short)id {
	short _id;
	ResType _type;
	Str255 _name;
	GetResInfo(_handle, &_id, &_type, _name);
	return _id;
}

- (NSString *)name {
	short _id;
	ResType _type;
	Str255 _name;
	GetResInfo(_handle, &_id, &_type, _name);
	return [(NSString*)CFStringCreateWithPascalString(NULL, 
_name, kCFStringEncodingMacRomanLatin1) autorelease];
}

- (Class)nativeRepresentationClass {
	return nil;
}

- (id)nativeRepresentation {
	return nil;
}

- (void)dealloc {
	if (_handle) {
		ReleaseResource(_handle);
	}
	[super dealloc];
}

@end