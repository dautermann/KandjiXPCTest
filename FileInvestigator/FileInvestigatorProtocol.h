//
//  FileInvestigatorProtocol.h
//  FileInvestigator
//
//  Created by Michael Dautermann on 9/23/21.
//

#import <Foundation/Foundation.h>

// The protocol that this service will vend as its API. This header file will also need to be visible to the process hosting the service.
@protocol FileInvestigatorProtocol
- (void)fetchFolderInfoForPath: (NSString *)path withReply:(void (^)(id))reply;
@end
