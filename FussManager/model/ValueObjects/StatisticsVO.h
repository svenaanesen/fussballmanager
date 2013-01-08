//
//  StatisticsVO.h
//  FussManager
//
//  Created by Sven Aanesen on 07.01.13.
//  Copyright (c) 2013 Eniro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticsVO : NSObject


@property (strong) NSString *id;
@property (strong) NSString *name;
@property (readwrite) int totalpoints;
@property (readwrite) double lastpoints;
@property (readwrite) int totalgoals;
@property (readwrite) int totalgames;

@end
