//
//  MatchScoreView.m
//  FussballManager
//
//  Created by Sven Aanesen on 05.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import "MatchScoreView.h"

@implementation MatchScoreView

- (id)initWithFrame:(CGRect)frame andValue:(NSString *)value
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setFont:[UIFont fontWithName:@"HelveticaNeue" size:120]];
        [_label setText:value];
        [_label setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:_label];
        
    }
    return self;
}

@end
