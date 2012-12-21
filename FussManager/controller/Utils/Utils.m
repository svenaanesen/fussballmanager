//
//  Utils.m
//  FussballManager
//
//  Created by Sven Aanesen on 07.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import "Utils.h"
//#import <CommonCrypto/CommonDigest.h>

@implementation Utils

+ (NSString *)createUniqueStringId
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef unique = CFUUIDCreateString(NULL, uuid);
	CFRelease(uuid);
	NSString *uuidStr = [NSString stringWithString:(__bridge NSString *)unique];
	CFRelease(unique);
	
	//NSLog(@"Unique string: %@", uuidStr);
	return uuidStr;
}

@end
