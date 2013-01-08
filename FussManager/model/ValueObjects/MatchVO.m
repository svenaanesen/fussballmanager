//
//  MatchVO.m
//  FussballManager
//
//  Created by Sven Aanesen on 05.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import "MatchVO.h"

@implementation MatchVO


- (void)parseInfo:(NSDictionary *)info
{
    
    if ([self getValueInObject:info fromKey:@"id"]) {
        [self setId:[self getValueInObject:info fromKey:@"id"]];
    }
    
    if ([self getValueInObject:info fromKey:@"userid_1"]) {
        [self setUserid1:[self getValueInObject:info fromKey:@"userid_1"]];
    }
    
    if ([self getValueInObject:info fromKey:@"userid_2"]) {
        [self setUserid2:[self getValueInObject:info fromKey:@"userid_2"]];
    }
    
    if ([self getValueInObject:info fromKey:@"goals_user1"]) {
        [self setGoals1:[NSNumber numberWithInt:[[self getValueInObject:info fromKey:@"goals_user1"] intValue]]];
    }
    
    if ([self getValueInObject:info fromKey:@"goals_user2"]) {
        [self setGoals2:[NSNumber numberWithInt:[[self getValueInObject:info fromKey:@"goals_user2"] intValue]]];
    }
    
    if ([self getValueInObject:info fromKey:@"date"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *__date = [dateFormatter dateFromString:[self getValueInObject:info fromKey:@"date"]];
        [self setDate:__date];
    }
    
}

@end
