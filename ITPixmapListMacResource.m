#import "ITPixmapListMacResource.h"

@implementation ITPixmapListMacResource

+ (NSArray *)supportedResourceTypes {
	return [NSArray arrayWithObject:[NSString stringWithFourCharCode:'pxm#']];
}

- (Class)nativeRepresentationClass {
	return [NSArray class];
}

- (id)nativeRepresentation {
	return nil;
}

@end