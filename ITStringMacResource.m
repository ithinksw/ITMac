#import "ITStringMacResource.h"

@implementation ITStringMacResource

+ (NSArray *)supportedResourceTypes {
	return [NSArray arrayWithObject:[NSString stringWithFourCharCode:'STR ']];
}

- (Class)nativeRepresentationClass {
	return [NSString class];
}

- (id)nativeRepresentation {
	return nil;
}

@end