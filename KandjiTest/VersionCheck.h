//
//  VersionCheck.h
//  Exam4
//
//  Created by Michael Dautermann on 1/18/09.
//  Copyright 2009 Try To Guess My Company Name. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
	int	major;
	int minor;
	int build;
    int bonus;
} VersionStruct;

@interface VersionCheck : NSObject {
	VersionStruct*	mCurrentVersion;
}

+ (BOOL) areWeRunningOnSomethingEqualToOrBetterThan: (NSString *) systemVersion;
+ (BOOL) displayPracticeExamNagScreen;
+ (NSString *) getAppVersionString;
+ (NSString *) getInternalVersionString;
+ (NSString *) getSystemVersion;
+ (BOOL) hasItemHasBeenAddedToDockYet;
- (BOOL) isThisVersionCurrent: (VersionStruct *) otherVersion;
+ (BOOL) isThis: (VersionStruct *) first sameOrBetterThan: (VersionStruct *) second;
+ (BOOL) isThis:(VersionStruct *)first betterThan:(VersionStruct *)second;
// + (BOOL) isThisLeopardOrBetter;
+ (void) setItemHasBeenAddedToDockValueForCurrentVersion;
+ (void) setPracticeExamCompletedValueForCurrentVersion;
- (void) setToCurrentVersion;
- (void) setVersionToExamine: (NSString *) versionStringToSet;
+ (VersionStruct *) versionStructFromString: (NSString *) versionString;

@end
