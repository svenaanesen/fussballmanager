//
//  MatchRegistrationViewController.h
//  FussballManager
//
//  Created by Sven Aanesen on 05.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchRegistrationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {

    NSArray *datasource;
    NSMutableArray *selectedPlayersTeam1;
    NSMutableArray *selectedPlayersTeam2;
    
    UITableView     *team1tableview;
    UITableView     *team2tableview;
    
    UIPickerView    *team1scoreboard;
    UIPickerView    *team2scoreboard;
    
    int goalsTeam1;
    int goalsTeam2;
    
    NSArray *goalList;
}

@end
