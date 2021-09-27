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
                // to keep this simple, we'll use a colon -- a reserved character when messing with POSIX -- to separate paths
                response = [response stringByAppendingFormat:@":%@", filename];
            }];
        } else {
            // it's a file... return everything we can find out about this file
            NSError *error;
            NSDictionary * attributes = [fm attributesOfItemAtPath:path error:&error];
            syslog(LOG_NOTICE, "fetchFolderInfoForPath error is %s", [[error localizedDescription] UTF8String]);
            syslog(LOG_NOTICE, "fetchFolderInfoForPath attributes keys is %ld", [[attributes allKeys] count]);
            response = [attributes description];
            syslog(LOG_NOTICE, "fetchFolderInfoForPath response is %s", [response UTF8String]);
        }
    }
    reply(response);
}

@end
