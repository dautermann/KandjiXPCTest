//
//  FileInvestigator.m
//  FileInvestigator
//
//  Created by Michael Dautermann on 9/23/21.
//

#import "FileInvestigator.h"

@implementation FileInvestigator

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply {
    NSString *response = [aString uppercaseString];
    reply(response);
}

@end
