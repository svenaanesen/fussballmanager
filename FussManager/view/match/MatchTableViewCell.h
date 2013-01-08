//
//  MatchTableViewCell.h
//  FussManager
//
//  Created by Sven Aanesen on 07.01.13.
//  Copyright (c) 2013 Eniro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MatchVO.h"

@interface MatchTableViewCell : UITableViewCell {


    UILabel *dateLabel;
    UILabel *user1Label;
    UILabel *user2Label;
    UILabel *result1Label;
    UILabel *result2Label;
}



- (void)setCellContent:(MatchVO *)matchinfo;

@end
