//
//  TeamVO.m
//  FussballManager
//
//  Created by Sven Aanesen on 06.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import "TeamVO.h"

@implementation TeamVO


- (void)setDefaultValues
{
    [self setTeamname:@""];
}

- (void)parseInfo:(NSDictionary *)info
{
    
    if ([self getValueInObject:info fromKey:@"id"]) {
        [self setId:[self getValueInObject:info fromKey:@"id"]];
    }
    
    if ([self getValueInObject:info fromKey:@"teamname"]) {
        [self setTeamname:[self getValueInObject:info fromKey:@"teamname"]];
    }
    
    if ([self getValueInObject:info fromKey:@"userid_1"]) {
        [self setUserid1:[self getValueInObject:info fromKey:@"userid_1"]];
    }
    
    if ([self getValueInObject:info fromKey:@"userid_2"]) {
        [self setUserid2:[self getValueInObject:info fromKey:@"userid_2"]];
    }
    
    // set default rating to 500
    [self setRating:[NSNumber numberWithDouble:500]];
    
}

@end
