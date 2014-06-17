

#import "StaticLibraryWindowController.h"

@interface NSNib (StaticLibraryWindowController)
+ (instancetype) StaticLibraryWindowController;
@end

@implementation StaticLibraryWindowController

+ (instancetype) controller
{
	StaticLibraryWindowController * result; return result = self.class.new,
	[NSNib.StaticLibraryWindowController  instantiateWithOwner:result topLevelObjects:nil], result;
}

@end
