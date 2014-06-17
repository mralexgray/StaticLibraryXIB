
//  AppDelegate.m test
//  Created by Niels Gabel on 11/3/13. Copyright (c) 2013 Niels Gabel. All rights reserved.

#import "AppDelegate.h"
#import "StaticLibraryWindowController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification*)n
{
	_testController = StaticLibraryWindowController.controller;
}

@end




