//
//  MatchScoreView.h
//  FussballManager
//
//  Created by Sven Aanesen on 05.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchScoreView : UIView

@property (strong) UILabel *label;

- (id)initWithFrame:(CGRect)frame andValue:(NSString *)value;

//- (void)updateLabel:(NSString *)value;


@end
