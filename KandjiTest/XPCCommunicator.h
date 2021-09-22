//
//  XPCCommunicator.h
//  KandjiTest
//
//  Created by Michael Dautermann on 9/22/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPCCommunicator : NSObject

- (void) fetchFolderInfoForPath: (NSString *)path;

@end

NS_ASSUME_NONNULL_END
