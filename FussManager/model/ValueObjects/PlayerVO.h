//
//  PlayerVO.h
//  FussballManager
//
//  Created by Sven Aanesen on 05.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import "BaseValueObject.h"

@interface PlayerVO : BaseValueObject

@property (strong) NSString *id;
@property (strong) NSString *name;
@property (strong) NSString *department;
@property (strong) NSString *imagereference;
@property (strong) NSNumber *rating;

@end
