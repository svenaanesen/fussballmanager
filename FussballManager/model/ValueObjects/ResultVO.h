//
//  ResultVO.h
//  FussballManager
//
//  Created by Sven Aanesen on 06.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import "BaseValueObject.h"

@interface ResultVO : BaseValueObject

@property (strong) NSNumber *id;
@property (strong) NSString *userid;
@property (strong) NSNumber *points;
@property (strong) NSNumber *goals;
@property (strong) NSNumber *matchid;

@end
