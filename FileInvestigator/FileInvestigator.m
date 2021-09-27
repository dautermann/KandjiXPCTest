//
//  FileInvestigator.m
//  FileInvestigator
//
//  Created by Michael Dautermann on 9/23/21.
//

#import "FileInvestigator.h"
#import <syslog.h>

@implementation FileInvestigator

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply {
    NSString *response = [aString uppercaseString];
    reply(response);
}

- (void) fetchFolderInfoForPath: (NSString *)path withReply:(void (^)(NSString *))reply {
    syslog(LOG_NOTICE, "fetchFolderInfoForPath %s", [path UTF8String]);
    __block NSString *response = path;
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL directoryFlag;
    
    if ([fm fileExistsAtPath:path isDirectory:&directoryFlag]) {
        if (directoryFlag) {
            NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
            [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString *filename = (NSString *)obj;
//                NSString *extension = [[filename pathExtension] lowercaseString];
//                if ([extension isEqualToString:@"mp3"]) {
//                    [mp3Files addObject:[path stringByAppendingPathComponent:filename]];
//                }
                response = [response stringByAppendingFormat:@" %@", filename];
            }];
        } else {
            // it's a file...
        }
    }
    reply(response);
}

@end
