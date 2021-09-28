//
//  FileInvestigator.m
//  FileInvestigator
//
//  Created by Michael Dautermann on 9/23/21.
//

#import "FileInvestigator.h"
#import <syslog.h>

@implementation FileInvestigator

- (void) fetchFolderInfoForPath: (NSString *)path withReply:(void (^)(id))reply {
    // syslog(LOG_NOTICE, "fetchFolderInfoForPath %s", [path UTF8String]);
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL directoryFlag;

    if ([fm fileExistsAtPath:path isDirectory:&directoryFlag]) {
        if (directoryFlag) {
            NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
            reply(dirs);
            syslog(LOG_NOTICE, "fetchFolderInfoForPath %ld folders being returned", [dirs count]);
        } else {
            // it's a file... return everything we can find out about this file
            NSError *error;
            NSDictionary * attributes = [fm attributesOfItemAtPath:path error:&error];
            if (error != nil) {
                syslog(LOG_NOTICE, "fetchFolderInfoForPath error is %s", [[error localizedDescription] UTF8String]);
            } else {
                reply(attributes);
            }
        }
    } else {
        syslog(LOG_NOTICE, "fetchFolderInfoForPath no file at %s", [path UTF8String]);
    }
}

@end
