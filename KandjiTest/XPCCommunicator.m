//
//  XPCCommunicator.m
//  KandjiTest
//
//  Created by Michael Dautermann on 9/22/21.
//

#import "XPCCommunicator.h"

@implementation XPCCommunicator

- (void) sendCommandToHelperTool {

    xpc_connection_t connection = xpc_connection_create_mach_service("com.apple.bsd.SMJobBlessHelper", NULL, XPC_CONNECTION_MACH_SERVICE_PRIVILEGED);

    if (!connection) {
        NSLog(@"Failed to create XPC connection.");
        return;
    }

    xpc_connection_set_event_handler(connection, ^(xpc_object_t event) {
        xpc_type_t type = xpc_get_type(event);

        if (type == XPC_TYPE_ERROR) {

            if (event == XPC_ERROR_CONNECTION_INTERRUPTED) {
                NSLog(@"XPC connection interupted.");

            } else if (event == XPC_ERROR_CONNECTION_INVALID) {
                NSLog(@"XPC connection invalid, releasing.");
#if !__has_feature(objc_arc)
                xpc_release(connection);
#endif
            } else {
                NSLog(@"Unexpected XPC connection error.");
            }

        } else {
            NSLog(@"Unexpected XPC connection event.");
        }
    });

    xpc_connection_resume(connection);

    xpc_object_t message = xpc_dictionary_create(NULL, NULL, 0);
    const char* request = "Hi there, helper service.";
    xpc_dictionary_set_string(message, "request", request);

    NSLog(@"Sending request: %s", request);

    xpc_connection_send_message_with_reply(connection, message, dispatch_get_main_queue(), ^(xpc_object_t event) {
        const char* response = xpc_dictionary_get_string(event, "reply");
        NSLog(@"Received response: %s.", response);
    });

}

- (void) fetchFolderInfoForPath: (NSString *)path {
    xpc_connection_t connection = xpc_connection_create_mach_service("com.extegrity.LogTool.mach", NULL, XPC_CONNECTION_MACH_SERVICE_PRIVILEGED);

    if (!connection) {
        NSLog(@"Failed to create XPC connection.");
        return;
    }

    xpc_connection_set_event_handler(connection, ^(xpc_object_t event) {
        xpc_type_t type = xpc_get_type(event);

        if (type == XPC_TYPE_ERROR) {

            if (event == XPC_ERROR_CONNECTION_INTERRUPTED) {
                NSLog(@"XPC connection interupted.");

            } else if (event == XPC_ERROR_CONNECTION_INVALID) {
                NSLog(@"XPC connection invalid, releasing.");
            } else {
                NSLog(@"Unexpected XPC connection error.");
            }

        } else {
            NSLog(@"Unexpected XPC connection event.");
        }
    });

    xpc_connection_resume(connection);

    xpc_object_t message = xpc_dictionary_create(NULL, NULL, 0);

    /// send path to helper tool
    xpc_dictionary_set_string(message, "path", (char *) [path UTF8String]);
    NSLog(@"Sending XPC Request for Path: %@", path);

    xpc_connection_send_message_with_reply(connection, message, dispatch_get_main_queue(), ^(xpc_object_t event) {
        const char* response = xpc_dictionary_get_string(event, "reply");
        NSLog(@"Received response: %s.", response);
    });
}

@end
