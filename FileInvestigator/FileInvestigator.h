//
//  FileInvestigator.h
//  FileInvestigator
//
//  Created by Michael Dautermann on 9/23/21.
//

#import <Foundation/Foundation.h>
#import "FileInvestigatorProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface FileInvestigator : NSObject <FileInvestigatorProtocol>
@end
