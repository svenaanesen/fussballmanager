//
//  Communicator.m
//  iWishes
//
//  Created by Sven Aanesen on 03/31/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Communicator.h"
#import "AppModel.h"
#import "Util.h"

@implementation Communicator

- (void)abortRequest 
{
    if (inProgress) {
        if (_connection != nil) {
            [_connection cancel];
            [self connectionCleanup];
        }
    }
}


- (void)sendRequest:(NSString *)post toURL:(NSString *)postUrl
{
    if (inProgress) {
        if (_allowMultipleRequests) {
            // add to wait list
            if (requestsOnHold == nil) 
                requestsOnHold = [[NSMutableArray alloc] init];
            
            [requestsOnHold addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:post, postUrl, nil] forKeys:[NSArray arrayWithObjects:@"post", @"postUrl", nil]]];
            
        } else {
            // abort the current connection
            [self abortRequest];
        }
        
    } else {
        responseData = [[NSMutableData alloc] init];
        
        NSLog(@"SEND: %@ to %@", post, postUrl);
        
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:postUrl]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        inProgress = YES;
        _connection =  [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

#pragma mark -
#pragma mark connection delegate methods

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)aRequest redirectResponse:(NSURLResponse *)aResponse;
{
	NSLog(@"In connection: willSendRequest: %@ redirectResponse: %@", aRequest, aResponse);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[_delegate willSendRequest:aRequest];
	return aRequest;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"connection: didReceiveResponse: %@, %lld", [response URL], [response expectedContentLength]);
	[responseData setLength:0];
	[_delegate didReceiveResponse:response];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)urlconnection didFailWithError:(NSError *)error {
	NSLog(@"Connection failed: %@", [error description]);
	[_delegate didFailWithError:error];
	[self connectionCleanup];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)urlconnection {
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Connection did finish loading with result: %@", responseString);
   
    if (responseString != nil) {
        [_delegate finishedReceivingData:[NSArray arrayWithObject:responseString]];
    }
    
    [self connectionCleanup];
    
    if (requestsOnHold != nil) {
        if ([requestsOnHold count] > 0) {
            NSDictionary *nextRequest = (NSDictionary *)[requestsOnHold objectAtIndex:0];
            [self sendRequest:[nextRequest objectForKey:@"post"] toURL:[nextRequest objectForKey:@"postUrl"]];
            
            [requestsOnHold removeObjectAtIndex:0];
            
        } else {
            requestsOnHold = nil;
            //_allowMultipleRequests = NO;
        }
    }
}

- (void)connectionCleanup {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (responseData != nil) {
        responseData = nil;
    }
    if (_connection != nil) {
        _connection = nil;
    }
    inProgress = NO;
}


#pragma mark -
#pragma mark connection methods

/*
- (void)saveNewWishList:(WishlistMO *)wishlist
{
    NSLog(@"Communicator.saveNewWishList()");
    NSMutableString *post = [[NSMutableString alloc] initWithString:@""];
    [post appendFormat:@"id=%@", [wishlist shareid]];
    [post appendFormat:@"&name=%@", [Util urlencode:[[wishlist name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [post appendFormat:@"&type=%@", [wishlist type]];
    [post appendFormat:@"&shared=%@", @"1"];
    [post appendFormat:@"&lastused=%@", @""];
    
    [self sendRequest:post toURL:[AppModel ADD_NEW_WISHLIST_URL]];
    [post release];
}

- (void)getWishlist:(NSString *)wishlistId
{
    
}

- (void)deleteWishlist:(NSString *)wishlistId
{
    NSLog(@"Communicator.deleteWishlist()");
    NSMutableString *post = [[NSMutableString alloc] initWithString:@""];
    [post appendFormat:@"id=%@", wishlistId];
    
    [self sendRequest:post toURL:[AppModel DELETE_WISHLIST_URL]];
    [post release];
}

- (void)updateWishlistWithList:(WishlistMO *)wishlist
{
    NSLog(@"Communicator.updateWishlist()");
    NSMutableString *post = [[NSMutableString alloc] initWithString:@""];
    [post appendFormat:@"id=%@", [wishlist shareid]];
    [post appendFormat:@"&name=%@", [Util urlencode:[[wishlist name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [post appendFormat:@"&type=%@", [wishlist type]];
    [post appendFormat:@"&shared=%@", @"1"];
    [post appendFormat:@"&lastused=%@", @""];
    
    [self sendRequest:post toURL:[AppModel UPDATE_WISHLIST_URL]];
    [post release];
}

- (void)saveProductToWishlist:(ProductMO *)product toWishListWithId:(NSString *)wishlistId
{
    NSLog(@"Communicator.saveNewWishList()");
    NSMutableString *post = [[NSMutableString alloc] initWithString:@""];
    [post appendFormat:@"prodid=%@", [product prodid]];
    [post appendFormat:@"&name=%@", [Util urlencode:[[product name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [post appendFormat:@"&price=%@", [Util urlencode:[[product price] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [post appendFormat:@"&link=%@", [product link]];
    [post appendFormat:@"&completed=%i", [product completed]];
    [post appendFormat:@"&comment=%@", [Util urlencode:[[product comment] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [post appendFormat:@"&wishlistid=%@", [[product wishlist] shareid]];
    
    [self sendRequest:post toURL:[AppModel ADD_NEW_WISH_URL]];
    [post release];
}

- (void)updateProductInWishlist:(ProductMO *)product inWishListWithId:(NSString *)wishlistId
{
    NSLog(@"Communicator.updateProductInWishlist() %@", [product prodid]);
    NSMutableString *post = [[NSMutableString alloc] initWithString:@""];
    [post appendFormat:@"prodid=%@", [product prodid]];
    [post appendFormat:@"&name=%@", [Util urlencode:[[product name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [post appendFormat:@"&price=%@", [Util urlencode:[[product price] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [post appendFormat:@"&link=%@", [product link]];
    [post appendFormat:@"&completed=%i", [product completed]];
    [post appendFormat:@"&comment=%@", [Util urlencode:[[product comment] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [post appendFormat:@"&wishlistid=%@", [[product wishlist] shareid]];
    
    [self sendRequest:post toURL:[AppModel UPDATE_WISH_URL]];
    [post release];
}

- (void)getProductsFromWishlist:(NSString *)wishlistId
{
}

- (void)deleteProduct:(ProductMO *)product fromWishListWithId:(NSString *)wishlistId
{
    NSLog(@"Communicator.deleteWishlist()");
    NSMutableString *post = [[NSMutableString alloc] initWithString:@""];
    [post appendFormat:@"id=%@", [product prodid]];
    [post appendFormat:@"&wishlistid=%@", wishlistId];
    
    [self sendRequest:post toURL:[AppModel DELETE_WISH_URL]];
    [post release];
}
 */

@end
