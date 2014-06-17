//
//  main.m
//  denibber
//
//  Created by Alex Gray on 6/16/14.
//  Copyright (c) 2014 Niels Gabel. All rights reserved.
//

@import Foundation; @import Darwin;

#import "RunLoopController.h"

NSString* runCommand	(NSString* c) {	NSString* outP;	FILE *read_fp;	char buffer[BUFSIZ + 1]; size_t chars_read;

	memset(buffer, '\0', sizeof(buffer));
	if (!(read_fp = popen(c.UTF8String, "r"))) return nil;
  if ((chars_read = fread(buffer, sizeof(char), BUFSIZ, read_fp))) outP = @(buffer);
  pclose(read_fp);
	return outP;
}

#define _NS(X) @#X
#define HEX_DUMP HEX_DUMP
#define NIB_NAME NIB_NAME
#define HEX_LENGTH HEX_LENGTH

#define IBTOOL_OPTS " --output-format human-readable-text --compile "
#define IBTOOL_PATH "/usr/bin/ibtool "
#define NEWL "\n\n\t"
#define TEMPLATE @"\n// This file was autogenerated from %@, do not edit..\n\n@import AppKit;\n\n@implementation NSNib (" _NS(NIB_NAME) ")\n\n+ (instancetype) " _NS(NIB_NAME) " {" NEWL "NSData * data = [NSData dataWithBytesNoCopy:(void*)(const unsigned char[]){\n\n" _NS(HEX_DUMP) NEWL "}" NEWL "length:(NSUInteger){" NEWL  _NS(HEX_LENGTH) NEWL "} freeWhenDone:NO];" NEWL "return [NSNib.alloc initWithNibData:data bundle:nil];\n\n }" NEWL "@end"


//         HEX_DUMP=$(hexdump -v -e '1 1 "0x%02x, "' "$INPUT_BASE_NIB")
//      DATA_LENGTH=$(stat -f "%z" "$INPUT_BASE_NIB")
//
//sed -e "s/HEX_DUMP/$HEX_DUMP/" \
//    -e "s/NIB_NAME/${}/g" \
//    -e "s/HEX_LENGTH/$DATA_LENGTH/g" "${SRCROOT}/CompiledNibTemplate.m" \
//     > "$DERIVED_FILE_DIR/$INPUT_FILE_BASE.nib.m"


int main(int argc, const char * argv[]) { @autoreleasepool {

    int fileDescriptor; const char * fifo = "/tmp/denibberhandle";

    NSFileHandle * filehandleForReading; RunLoopController *runLoopController;

    [runLoopController = RunLoopController.new register]; __block BOOL done = NO;


    NSArray *args = NSProcessInfo.processInfo.arguments;
    if (args.count < 2) return printf("danger, I require AT LEAST 1 argument.. your nib...."), EXIT_FAILURE;

    NSString *INPUT_FILE      = args[1];
    NSString *INPUT_FILE_BASE = INPUT_FILE.stringByStandardizingPath.stringByDeletingPathExtension.lastPathComponent;

    if(mkfifo(fifo, 0666) == -1 && errno !=EEXIST) printf("Unable to open the named pipe %s", fifo);
          fileDescriptor  = open(fifo, O_RDWR | O_NDELAY);
    filehandleForReading  = [NSFileHandle.alloc initWithFileDescriptor:fileDescriptor closeOnDealloc:YES];

    [NSNotificationCenter.defaultCenter addObserverForName:NSFileHandleReadCompletionNotification object:filehandleForReading queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *n) {

      NSData *d = [n.userInfo valueForKey:NSFileHandleNotificationDataItem];
      NSLog(@"dataReady:%lu bytes", [d length]);

      NSMutableString *hex = [NSMutableString string];
      if ([d length]) {

          const unsigned char *buf = d.bytes;
          NSInteger i;
          for (i=0; i<d.length; ++i) [hex appendFormat:@"0x%02X, ", buf[i]];

//
//          unsigned char *bytes = (unsigned char *)[d bytes];
//          char temp[3];
//          int i = 0;
//          for (i = 0; i < [d length]; i++) { temp[0] = temp[1] = temp[2] = 0; (void)sprintf(temp, "%02x", bytes[i]);
//
//            [hex appendString:[NSString stringWithUTF8String:temp]];
//          }
      }

      //Tell the fileHandler to asychronusly report back
      //    [filehandleForReading readInBackgroundAndNotify];

  //      NSString *HEX_DUMP_RESULT = runCommand([NSString stringWithFormat:@"hexdump -v -e '1 1 \"0x%%02x, \"' \"%@\"",INPUT_FILE]);
  //      NSString *DATA_LENGTH     = runCommand([NSString stringWithFormat:@"stat -f \"%%z\" \"%@\"",INPUT_FILE]);

      NSString *theDoc = [[[[NSString stringWithFormat:TEMPLATE,INPUT_FILE]
                  stringByReplacingOccurrencesOfString:_NS(NIB_NAME)   withString:INPUT_FILE_BASE]
                  stringByReplacingOccurrencesOfString:_NS(HEX_LENGTH) withString:@(d.length).stringValue]//DATA_LENGTH]
                  stringByReplacingOccurrencesOfString:_NS(HEX_DUMP)   withString:hex];
//                                              [NSString stringWithFormat:@"%02X",[d bytes]]];// description]];//hex];

      NSString *saveTo = [[[INPUT_FILE.stringByDeletingLastPathComponent
                           stringByAppendingPathComponent:INPUT_FILE_BASE]stringByAppendingPathExtension:@"xib"]stringByAppendingPathExtension:@"m"];
      NSError *e;
      BOOL ok = [theDoc writeToFile:saveTo atomically:YES encoding:NSUTF8StringEncoding error:&e];
      !ok || e ? printf("AY!! %s\n", [e.localizedDescription UTF8String]), (void)nil :
      printf("Saved to .m at %s\n", saveTo.UTF8String);

      done = YES;
      [RunLoopController.mainRunLoopController signal];

    }];

    [filehandleForReading readInBackgroundAndNotify];

    runCommand([NSString stringWithFormat:@"" IBTOOL_PATH  IBTOOL_OPTS" %s %@", fifo, INPUT_FILE]);

    while ([runLoopController run]) if (done) break;
    [runLoopController deregister];
  }
    return 0;
}

