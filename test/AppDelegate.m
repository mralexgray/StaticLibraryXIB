//
//  AppDelegate.m
//  test
//
//  Created by Niels Gabel on 11/3/13.
//  Copyright (c) 2013 Niels Gabel. All rights reserved.
//

#import "AppDelegate.h"
#import "StaticLibraryWindowController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.testController = [ StaticLibraryWindowController controller ] ;
}

@end



int main(int argc, const char * argv[])
{
	return NSApplicationMain(argc, argv);
}
