//
//  ResultVO.m
//  FussballManager
//
//  Created by Sven Aanesen on 06.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import "ResultVO.h"

@implementation ResultVO


- (void)parseInfo:(NSDictionary *)info
{
    
    if ([self getValueInObject:info fromKey:@"id"]) {
        [self setId:[NSNumber numberWithInt:[[self getValueInObject:info fromKey:@"id"] intValue]]];
    }
    
    if ([self getValueInObject:info fromKey:@"userid"]) {
        [self setUserid:[self getValueInObject:info fromKey:@"userid"]];
    }
    
    if ([self getValueInObject:info fromKey:@"points"]) {
        [self setPoints:[NSNumber numberWithInt:[[self getValueInObject:info fromKey:@"points"] intValue]]];
    }
    
    if ([self getValueInObject:info fromKey:@"goals"]) {
        [self setGoals:[NSNumber numberWithInt:[[self getValueInObject:info fromKey:@"goals"] intValue]]];
    }
    
    if ([self getValueInObject:info fromKey:@"matchid"]) {
        [self setMatchid:[self getValueInObject:info fromKey:@"matchid"]];
    }
    
}


@end
