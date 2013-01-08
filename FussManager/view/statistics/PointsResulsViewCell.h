//
//  PointsResulsViewCell.h
//  FussManager
//
//  Created by Sven Aanesen on 07.01.13.
//  Copyright (c) 2013 Eniro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StatisticsVO.h"

@interface PointsResulsViewCell : UITableViewCell {

    UILabel *nameLabel;
    UILabel *matchLabel;
    UILabel *goalsLabel;
    UILabel *pointsLabel;
    UILabel *totalLabel;
    UILabel *lastLabel;
}


- (void)setCellContent:(StatisticsVO *)statistics;

@end
