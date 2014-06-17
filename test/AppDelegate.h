//
//  AppDelegate.h
//  test
//
//  Created by Niels Gabel on 11/3/13.
//  Copyright (c) 2013 Niels Gabel. All rights reserved.
//

#import <AppKit/AppKit.h>

@class StaticLibraryWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet    NSWindow * window;
@property                      NSWindow * otherWindow;
@property StaticLibraryWindowController * testController;

@end
