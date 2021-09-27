//
//  VersionCheck.m
//  Exam4
//
//  Created by Michael Dautermann on 1/18/09.
//  Copyright 2009 Try To Guess My Company Name. All rights reserved.
//

#import "VersionCheck.h"


@implementation VersionCheck

- (id) init
{
	self = [ super init ];
	if( self )
	{
		mCurrentVersion = NULL;
	}
	return self;
}

- (void) setVersionToExamine: (NSString *) versionStringToSet
{
	mCurrentVersion = [ VersionCheck versionStructFromString: versionStringToSet ];
}

- (void) setToCurrentVersion
{
	NSString * versionString;

	versionString = [ VersionCheck getAppVersionString ];
	mCurrentVersion = [ VersionCheck versionStructFromString: versionString ];
}

- (void) dealloc
{
	if( mCurrentVersion )
		free( mCurrentVersion );
#if !__has_feature(objc_arc)
	[super dealloc];
#endif
}

- (BOOL) isThisVersionCurrent: (VersionStruct*) otherVersion
{
	BOOL	current = YES;

	if( otherVersion->major < mCurrentVersion->major )
		current = NO;
	else {
		if( otherVersion->major == mCurrentVersion->major )
		{
			if( otherVersion->minor < mCurrentVersion->minor )
				current = NO;
			else {
				if( otherVersion->minor == mCurrentVersion->minor )
				{
					if( otherVersion->build < mCurrentVersion->build )
						current = NO;
                    
                    // if there is a bonus (fourth) digit in the version number, use it in our calculations
                    if( otherVersion->bonus >= 0)
                    {
                        if( otherVersion->bonus < mCurrentVersion->bonus)
                            current = NO;
                    }
				}
			}
		}
	}
	
	return( current );
}

+ (VersionStruct* ) versionStructFromString: (NSString *) versionString
{
	NSArray	*		versionPieces;
	NSString *		pieceString;
	NSUInteger		arrayCount;
	VersionStruct*	newStruct;

    // needs a versionString that's longer than two digits, and also should contain only the below valid characters
    NSCharacterSet *numbersAndDecimalSet = [NSCharacterSet characterSetWithCharactersInString: @"0123456789."];
    if(( [versionString length] > 2) && ([numbersAndDecimalSet isSupersetOfSet: [NSCharacterSet characterSetWithCharactersInString: versionString]] == NO))
	{
        NSLog(@"something is very wrong with the versionString of %@", versionString);
		return NULL;
	}
	
	newStruct = ( VersionStruct* ) malloc( sizeof( VersionStruct) );
	if( NULL != newStruct )
	{
        newStruct->major = 0;

        newStruct->minor = newStruct->build = -1;
        
        newStruct->bonus = -1;
        
		versionPieces = [ versionString componentsSeparatedByString: @"." ];
		if( NULL != versionPieces )
		{
			arrayCount = [ versionPieces count ];
			
			switch( arrayCount )
			{
				default :
#if __NEW_LOGGING__
					NSLog( [ NSString stringWithFormat: @"more than 4 pieces to version string %@", versionString ] );
#else
					NSLog( @"more than 4 pieces to version string %@", versionString);
#endif
                // there are no "breaks" in this switch statement as
                // we fill out the structure based on how many items are in the NSArray
                case 4 :
                    pieceString = [ versionPieces objectAtIndex: 3 ];
                    if(NULL != pieceString )
                    {
                        newStruct->bonus = [ pieceString intValue ];
                    }
				case 3 :
					pieceString = [ versionPieces objectAtIndex: 2 ];
					if( NULL != pieceString )
					{
						newStruct->build = [ pieceString intValue ];
					}
				case 2 :
					pieceString = [ versionPieces objectAtIndex: 1 ];
					if( NULL != pieceString )
					{
						newStruct->minor = [ pieceString intValue ];
					}
				case 1 :
					pieceString = [ versionPieces objectAtIndex: 0 ];
					if( NULL != pieceString )
					{
						newStruct->major = [ pieceString intValue ];
					}
			}
		}
	}
	return( newStruct );
}

+ (BOOL) isThis: (VersionStruct *) first sameOrBetterThan: (VersionStruct *) second
{
	// we should always be running under "10"
	if(first->major < second->major)
		return NO;
	
	if(first->major == second->major)
	{
		// 10.4 < 10.5 ??
		if(first->minor < second->minor)
			return NO;
			
		if(first->minor == second->minor)
		{
			// 10.5.0 < 10.5.1 ??
			if(first->build < second->build)
				return NO;
            
            // if the bonus (fourth) field is not -1, then we should
            // consider it...
            if((first->build == second->build) && (second->bonus >= 0))
            {
                if(first->bonus < second->bonus)
                    return NO;
            }
		}
	}
	return YES;
}


+ (BOOL) isThis:(VersionStruct *)first betterThan:(VersionStruct *)second
{
    BOOL sameOrBetter = [VersionCheck isThis:first sameOrBetterThan:second];
    
    if(sameOrBetter)
    {
        // is it the same??
        if(first->major == second->major && first->minor == second->minor && first->build == second->build)
        {
            if(first->bonus >= 0)
            {
                if(second->bonus > first->bonus)
                    return YES;
            }
            return NO;
        }
        return YES;
    }
    return NO;
}

+ (BOOL) areWeRunningOnSomethingEqualToOrBetterThan: (NSString *) systemVersion
{
	NSString * currentSysVersion = [VersionCheck getSystemVersion];
	VersionStruct* curSysVersionStruct= [VersionCheck versionStructFromString: currentSysVersion];
	VersionStruct* targetVersionStruct= [VersionCheck versionStructFromString: systemVersion];
	BOOL okayToContinue;

	okayToContinue = [VersionCheck isThis: curSysVersionStruct sameOrBetterThan: targetVersionStruct];
	
	free(curSysVersionStruct);
	free(targetVersionStruct);
	
	return(okayToContinue);
}

+ (NSString *) getInternalVersionString
{
	NSBundle*	bundle;
	NSString*	versionStr;

	//	load our version number from our bundle
	bundle = [NSBundle mainBundle];
	if ( bundle != NULL ) {		
		versionStr = [bundle objectForInfoDictionaryKey: @"InternalVersionNumber"];
		if (versionStr != NULL) {
			return( versionStr );
		}
	}
	return( @"CantFindInternalVersion" );
}

+ (NSString *) getAppVersionString
{
	NSBundle*	bundle;
	NSString*	versionStr;

	//	load our version number from our bundle
	bundle = [NSBundle mainBundle];
	if ( bundle != NULL ) {		
		versionStr = [bundle objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
		if (versionStr != NULL) {
			return( versionStr );
		}
		
		versionStr = [bundle objectForInfoDictionaryKey: @"CFBundleVersion"];
		if (versionStr != NULL) {
			return( versionStr );
		}
		
	} else {
		NSLog(@"getAppVersionString could not find bundle (this is bad)");
	}

	return( @"" );
}

#ifdef NOTUSEDANYMORE
+ (BOOL) isThisLeopardOrBetter
{
	SInt32	majorVersionNum, minorVersionNum;
	OSErr	oErr;

	majorVersionNum = minorVersionNum = 0;

	oErr = Gestalt(gestaltSystemVersionMajor,&majorVersionNum);
	if(noErr == oErr)
	{
		oErr = Gestalt(gestaltSystemVersionMinor,&minorVersionNum);
	} else {
		NSLog( @"getSystemVersion failed on majorVersionNum");
	}

	if(majorVersionNum)
	{
		NSLog( [NSString stringWithFormat: @"a major version that is not 10?? I see %d", majorVersionNum] );
	}

	if(minorVersionNum >= 5)
	{
		return YES;
	}
	
	return NO;
}
#endif // NOTUSEDANYMORE

+ (NSString *) getSystemVersion
{
	NSString * versionString;

#if TARGET_OS_IPHONE
#pragma warning (do the right thing for iOS here)
#else
    // available as of 10.9.2 --> http://stackoverflow.com/questions/11072804/how-do-i-determine-the-os-version-at-runtime-in-os-x-or-ios-without-using-gesta
    NSOperatingSystemVersion versionStruct = [[NSProcessInfo processInfo] operatingSystemVersion];
    
    versionString = [NSString stringWithFormat: @"%ld.%ld.%ld", (long)versionStruct.majorVersion, (long)versionStruct.minorVersion, (long)versionStruct.patchVersion];
#endif
	
	return versionString;
}

+ (BOOL) displayPracticeExamNagScreen
{
	NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
	NSDictionary * nagDictionary;
	NSString * currentAppVersion;
	NSNumber * nagValueForCurrentVersion;
	
	if(preferences)
	{
		nagDictionary = [preferences objectForKey: @"practiceExamNag"];
		if(nagDictionary)
		{
#ifdef DEBUG
			NSLog(@"Nag Dictionary: %@", nagDictionary);
#endif
			// we have a nag dictionary, check to see if there is an entry for the current version in here...
			currentAppVersion = [VersionCheck getInternalVersionString];
			if(currentAppVersion)
			{
#ifdef DEBUG
				NSLog(@"Current App Version: %@", currentAppVersion);
#endif
				nagValueForCurrentVersion = [nagDictionary objectForKey: currentAppVersion];
				if(nagValueForCurrentVersion)
				{
					if([nagValueForCurrentVersion boolValue] == YES)
						return NO;
				}
			}
		}
	}
	return(YES);
}

+ (void) setPracticeExamCompletedValueForCurrentVersion
{
	NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
	NSDictionary * oldNagDictionary;
	NSMutableDictionary * nagDictionary;
	NSString * currentAppVersion;

	oldNagDictionary = [preferences objectForKey: @"practiceExamNag"];
	if(oldNagDictionary)
	{
		nagDictionary = [[NSMutableDictionary alloc] initWithCapacity: [oldNagDictionary count] + 1];
		if(nagDictionary)
			[nagDictionary setDictionary: oldNagDictionary];
	} else {
		nagDictionary = [[NSMutableDictionary alloc] initWithCapacity: 1];
	}
		
	if(nagDictionary)
	{
		currentAppVersion = [VersionCheck getInternalVersionString];
	
		[nagDictionary setObject: [NSNumber numberWithBool: YES] forKey: currentAppVersion];

		[preferences setObject: nagDictionary forKey: @"practiceExamNag"];
	}
}

+ (BOOL) hasItemHasBeenAddedToDockYet
{
	NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
	NSDictionary * nagDictionary;
	NSString * currentAppVersion;
	NSNumber * nagValueForCurrentVersion;
	
	if(preferences)
	{
		nagDictionary = [preferences objectForKey: @"dockItemAdded"];
		if(nagDictionary)
		{
			// we have a nag dictionary, check to see if there is an entry for the current version in here...
			currentAppVersion = [VersionCheck getInternalVersionString];
			if(currentAppVersion)
			{
				nagValueForCurrentVersion = [nagDictionary objectForKey: currentAppVersion];
				if(nagValueForCurrentVersion)
				{
					if([nagValueForCurrentVersion boolValue] == YES)
						return YES;
				}
			}
		}
	}
	return(NO);
}

+ (void) setItemHasBeenAddedToDockValueForCurrentVersion
{
	NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
	NSDictionary * oldNagDictionary;
	NSMutableDictionary * nagDictionary;
	NSString * currentAppVersion;

	oldNagDictionary = [preferences objectForKey: @"dockItemAdded"];
	if(oldNagDictionary)
	{
		nagDictionary = [[NSMutableDictionary alloc] initWithCapacity: [oldNagDictionary count] + 1];
		if(nagDictionary)
			[nagDictionary setDictionary: oldNagDictionary];
	} else {
		nagDictionary = [[NSMutableDictionary alloc] initWithCapacity: 1];
	}
		
	if(nagDictionary)
	{
		currentAppVersion = [VersionCheck getInternalVersionString];
	
		[nagDictionary setObject: [NSNumber numberWithBool: YES] forKey: currentAppVersion];

		[preferences setObject: nagDictionary forKey: @"dockItemAdded"];
	}
}

@end
