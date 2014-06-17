//
//  main.m
//  CLInibber
//
//  Created by Alex Gray on 6/16/14.
//  Copyright (c) 2014 Niels Gabel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "StaticLibraryWindowController.h"


@class StaticLibraryWindowController;
@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet    NSWindow * window;
@property                      NSWindow * otherWindow;
@property StaticLibraryWindowController * testController;

@end

@interface NSNib (AppDelegate)
+ (instancetype) MainMenu;
@end


@implementation AppDelegate

//+ (instancetype) sharedApplication
//{
//	AppDelegate * result = self.class.new;
//  NSArray *a;
//	BOOL OK = [NSNib.MainMenu  instantiateWithOwner:NSApp topLevelObjects:&a];
//  NSLog(@"Success? : %@, tops:%@",OK?@"OK": @"NAY", a);
////  [NSApp activateIgnoringOtherApps:YES];
////  [a[1] makeKeyAndOrderFront:nil];
////  [a[0] run];
//  return result;
//}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.testController = [ StaticLibraryWindowController controller ] ;
}

@end

int main(int argc, const char * argv[])
{
 @autoreleasepool {


	NSApplication *applicationObject = [NSApplication sharedApplication];
  [applicationObject setActivationPolicy:NSApplicationActivationPolicyRegular];
  NSArray *a;

//  [NSNib.MainMenu  instantiateWithOwner:NSApp topLevelObjects:&a];

//	NSString *mainNibName = [infoDictionary objectForKey:@"NSMainNibFile"];
	NSNib *mainNib = NSNib.MainMenu;
  BOOL OK = [mainNib instantiateWithOwner:applicationObject topLevelObjects:&a];
  NSLog(@"nib:%@ Success? : %@, tops:%@\n\n%@",mainNib, OK?@"OK": @"NAY", a,applicationObject.delegate);

  [applicationObject activateIgnoringOtherApps:YES];
  
	if ([applicationObject respondsToSelector:@selector(run)])
	{
		[applicationObject
			performSelectorOnMainThread:@selector(run)
			withObject:nil
			waitUntilDone:YES];
	}
	
//	[mainNib release];
  }

	return 0;

//  id x = [AppDelegate sharedApplication];

//  NSLog(@"%@",x);
//  [NSApp run];
//	return  8;  // [AppDelegate sharedApplication];//NSApplicationMain(argc, argv);
}

