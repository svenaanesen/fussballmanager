//
//  TeamVO.h
//  FussballManager
//
//  Created by Sven Aanesen on 06.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import "BaseValueObject.h"

@interface TeamVO : BaseValueObject

@property (strong) NSString *id;
@property (strong) NSString *teamname;
@property (strong) NSString *userid1;
@property (strong) NSString *userid2;
@property (strong) NSNumber *rating;

@end
