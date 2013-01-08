//
//  PointsResultsView.h
//  FussManager
//
//  Created by Sven Aanesen on 07.01.13.
//  Copyright (c) 2013 Eniro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointsResultsView : UIView <UITableViewDataSource, UITableViewDelegate> {
    
    UITableView *pointsTableView;
    
    NSArray *dataSource;
}

- (void)showSingelPointOverview;

- (void)showTeamPointOverview;

@end
