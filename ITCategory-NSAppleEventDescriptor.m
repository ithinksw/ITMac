#import "ITCategory-NSAppleEventDescriptor.h"
#import "ITAppleEventTools.h"

@implementation NSAppleEventDescriptor (ITMacCategory)

- (NSString *)carbonDescription {
	return _ITAEDescCarbonDescription(*[self aeDesc]);
}

@end