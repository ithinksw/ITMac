#import "ITMacResourceFile.h"

@implementation ITMacResourceFile

+ (HFSUniStr255)dataForkName {
	HFSUniStr255 dataForkName;
	FSGetDataForkName(&dataForkName);
	return dataForkName;
}

+ (HFSUniStr255)resourceForkName {
	HFSUniStr255 resourceForkName;
	FSGetResourceForkName(&resourceForkName);
	return resourceForkName;
}

- (id)initWithContentsOfFile:(NSString *)path {
	return [self initWithContentsOfFile:path fork:[ITMacResourceFile dataForkName]];
}

- (id)initWithContentsOfFile:(NSString *)path fork:(HFSUniStr255)namedFork {
	if (self = [super init]) {
		if (FSPathMakeRef([path fileSystemRepresentation], &_fileReference, NULL) == noErr) {
			FSOpenResourceFile(&_fileReference, namedFork.length, namedFork.unicode, fsRdPerm, &_referenceNumber);
		} else {
			[super release];
			self = nil;
		}
	}
	return self;
}

- (ITMacResource *)resourceOfType:(ITMacResourceType)type withID:(short)idNum {
	return [[ITMacResource subclassForType:type] resourceWithHandle:GetResource((ResType)type, idNum)];
}

- (ITMacResource *)resourceOfType:(ITMacResourceType)type withName:(NSString *)name {
	Str255 _buffer;
	StringPtr _ptr = (StringPtr)CFStringGetPascalStringPtr((CFStringRef)name, kCFStringEncodingMacRomanLatin1);
	if (_ptr == NULL) {
		if (CFStringGetPascalString((CFStringRef)name, _buffer, 256, kCFStringEncodingMacRomanLatin1)) {
			_ptr = _buffer;
		} else {
			return nil;
		}
	}
	return [[ITMacResource subclassForType:type] resourceWithHandle:GetNamedResource((ResType)type,_ptr)];
}

- (void)dealloc {
	if (_referenceNumber) {
		CloseResFile(_referenceNumber);
	}
	[super dealloc];
}

@end