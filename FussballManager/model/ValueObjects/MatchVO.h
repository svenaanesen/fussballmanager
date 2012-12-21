//
//  MatchVO.h
//  FussballManager
//
//  Created by Sven Aanesen on 05.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import "BaseValueObject.h"

@interface MatchVO : BaseValueObject

@property (strong) NSString *id;
@property (strong) NSString *userid1;
@property (strong) NSString *userid2;
@property (strong) NSNumber *goals1;
@property (strong) NSNumber *goals2;
@property (strong) NSDate   *date;

@end
