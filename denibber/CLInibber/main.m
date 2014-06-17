
//  main.m CLInibber
//  Created by Alex Gray on 6/16/14.  Copyright (c) 2014 Niels Gabel. All rights reserved.

#import "AppDelegate.h"
#import "StaticLibraryWindowController.h"

@interface NSNib (AppDelegate) + (instancetype) MainMenu; @end

int main(int argc, const char * argv[]) { @autoreleasepool {

    [NSApplication.sharedApplication setActivationPolicy:NSApplicationActivationPolicyRegular];

    NSArray *tops; NSNib *mainNib = NSNib.MainMenu; BOOL OK;

     OK = [mainNib instantiateWithOwner:NSApplication.sharedApplication topLevelObjects:&tops];

    printf("nib:%s ok:%s tops:%s", mainNib.description.UTF8String, OK ? "OK": "NAY", tops.description.UTF8String);

    [NSApp activateIgnoringOtherApps:YES]; [NSApp run];

  }

	return 0;
}


//  id x = [AppDelegate sharedApplication];

//  NSLog(@"%@",x);
//  [NSApp run];
//	return  8;  // [AppDelegate sharedApplication];//NSApplicationMain(argc, argv);
//	NSString *mainNibName = [infoDictionary objectForKey:@"NSMainNibFile"];
