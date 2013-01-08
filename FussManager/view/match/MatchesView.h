//
//  MatchesView.h
//  FussManager
//
//  Created by Sven Aanesen on 07.01.13.
//  Copyright (c) 2013 Eniro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MatchViewTypeSingle = 1,
    MatchViewTypeTeam = 2
} MatchViewType;



@interface MatchesView : UIView <UITableViewDataSource, UITableViewDelegate> {

    UITableView *matchesTableView;
    
    NSArray *dataSource;
}

@property (readwrite) MatchViewType matchViewType;


- (void)showSingelMatches;

- (void)showTeamMatches;

@end
