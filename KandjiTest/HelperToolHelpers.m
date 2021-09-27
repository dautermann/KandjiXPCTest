//
//  HelperToolManager.m
//  KandjiTest
//
//  Created by Michael Dautermann on 9/22/21.
//

#import "HelperToolManager.h"

@implementation HelperToolManager

- (void) installHelperToolsIfNecessary
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *errorPointer = nil;

        // let's make sure we have the latest
        BOOL shouldInstallFileInvestigator = [HelperToolHelpers shouldInstallHelperTool: @"com.myke.fileinvestigator"];
        if (shouldInstallFileInvestigator)
        {
            AuthorizationRef authRef = [HelperToolHelpers createAuthRef];
            if (authRef == NULL) {
                NSLog( @"IX Authorization failed");
                return;
            }

            if (shouldInstallNoInternetDuringExam == TRUE)
            {
                [HelperToolHelpers installHelperToolNamed:@"com.extegrity.NoInternetDuringExam" withErrorPointer:&errorPointer andAuthRef: authRef];
            }

            if (shouldInstallLogTool == TRUE)
            {
                [HelperToolHelpers installHelperToolNamed:@"com.extegrity.LogTool" withErrorPointer:&errorPointer andAuthRef: authRef];
            }
        }
    });
}

@end
