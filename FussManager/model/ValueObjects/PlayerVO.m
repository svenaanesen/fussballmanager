//
//  PlayerVO.m
//  FussballManager
//
//  Created by Sven Aanesen on 05.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import "PlayerVO.h"

@implementation PlayerVO


- (void)setDefaultValues
{
    [self setName:@""];
    [self setDepartment:@""];
    [self setImagereference:@""];
}

- (void)parseInfo:(NSDictionary *)info
{
    
    if ([self getValueInObject:info fromKey:@"id"]) {
        [self setId:[self getValueInObject:info fromKey:@"id"]];
    }
    
    if ([self getValueInObject:info fromKey:@"name"]) {
        [self setName:[self getValueInObject:info fromKey:@"name"]];
    }
    
    if ([self getValueInObject:info fromKey:@"department"]) {
        [self setDepartment:[self getValueInObject:info fromKey:@"department"]];
    }
    
    if ([self getValueInObject:info fromKey:@"imagereference"]) {
        [self setImagereference:[self getValueInObject:info fromKey:@"imagereference"]];
    }
    
}


@end
