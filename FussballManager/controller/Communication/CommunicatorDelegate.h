//
//  CommunicatorDelegate.h
//  iWishes
//
//  Created by Sven Aanesen on 04/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@protocol CommunicatorDelegate

- (void)willSendRequest:(NSURLRequest *)request;
- (void)didReceiveResponse:(NSURLResponse *)response;
- (void)didFailWithError:(NSError *)error;
- (void)finishedReceivingData:(NSArray *)resultArray;

@end