//
//  StatisticsViewController.h
//  FussManager
//
//  Created by Sven Aanesen on 07.01.13.
//  Copyright (c) 2013 Eniro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsViewController : UIViewController {

    UISegmentedControl *navigationBar;
    
    BOOL resultsRecieved;
    BOOL matchesRecieved;
    
    int statisticsViewYLoc;
    
    UIView *activeView;
    
    CGRect statisticsRect;
}

@end
