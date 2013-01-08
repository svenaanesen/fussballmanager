//
//  MatchesView.m
//  FussManager
//
//  Created by Sven Aanesen on 07.01.13.
//  Copyright (c) 2013 Eniro. All rights reserved.
//

#import "MatchesView.h"
#import "AppModel.h"
#import "MatchTableViewCell.h"

@implementation MatchesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


#pragma mark - table datasource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UITableViewCell";
    CGRect frame = CGRectMake(0, 0, matchesTableView.frame.size.width, 40);
    MatchTableViewCell *cell = (MatchTableViewCell *)[matchesTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[MatchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell setFrame:frame];
    }
    
    [cell setCellContent:[dataSource objectAtIndex:indexPath.row]];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}


#pragma mark - table delegate methods




#pragma mark - init methods

- (void)buildAndShowInterface
{
    matchesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    matchesTableView.delegate = self;
    matchesTableView.dataSource = self;
    [matchesTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [matchesTableView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:matchesTableView];
}

- (void)showSingelMatches
{
    // collect datasource for single matches
    NSMutableArray *sortarray = [NSMutableArray arrayWithArray:[[AppModel getAppModel] getAllSingelMatches]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [sortarray sortUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    dataSource = [NSArray arrayWithArray:sortarray];
    
    // show results
    [self buildAndShowInterface];
}

- (void)showTeamMatches
{
    // collect datasource for team matches
    NSMutableArray *sortarray = [NSMutableArray arrayWithArray:[[AppModel getAppModel] getAllTeamMatches]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [sortarray sortUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    dataSource = [NSArray arrayWithArray:sortarray];
    
    // show results
    [self buildAndShowInterface];
}

@end
