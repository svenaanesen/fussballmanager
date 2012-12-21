//
//  Communicator.h
//  iWishes
//
//  Created by Sven Aanesen on 03/31/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommunicatorDelegate.h"

@interface Communicator : NSObject {
    
@private
    BOOL inProgress;
    NSMutableData *responseData; 
    NSMutableArray *requestsOnHold;
}

@property (strong) id<CommunicatorDelegate> delegate;

@property (strong) NSURLConnection *connection;

@property (readwrite) BOOL allowMultipleRequests;


- (void)sendRequest:(NSString *)post toURL:(NSString *)postUrl;

- (void)abortRequest;

- (void)connectionCleanup;

@end
