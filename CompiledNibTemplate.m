#import <Cocoa/Cocoa.h>

@implementation NSNib (NIB_NAME)

+(instancetype)NIB_NAME
{
	NSData * data = [NSData dataWithBytesNoCopy:(void*)(const unsigned char[]){

HEX_DUMP

	} length:(NSUInteger){

  HEX_LENGTH

} freeWhenDone:NO];

  return [NSNib.alloc initWithNibData:data bundle:nil];
}

@end
