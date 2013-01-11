//
//  PointsResultsView.m
//  FussManager
//
//  Created by Sven Aanesen on 07.01.13.
//  Copyright (c) 2013 Eniro. All rights reserved.
//

#import "PointsResultsView.h"

#import "AppModel.h"
#import "PointsResulsViewCell.h"
#import "ApplicationConstants.h"

@implementation PointsResultsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {}
    return self;
}


#pragma mark - table datasource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UITableViewCell";
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 40);
    PointsResulsViewCell *cell = (PointsResulsViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[PointsResulsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell setFrame:frame];
    }
    
    [cell setCellContent:[dataSource objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - table delegate methdos

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    
    [sectionHeaderView setBackgroundColor:[UIColor lightGrayColor]];
    
    UIColor  *labelcolor = [UIColor darkTextColor];
    UIFont   *labelfont  = [UIFont fontWithName:APPLICATION_FONT_NORMAL_BOLD size:14];
    NSString *labeltext = @"# kamper";
    CGSize    labelsize = [labeltext sizeWithFont:labelfont];
    
    int xloc = (self.frame.size.width - (self.frame.size.width * 0.8)) / 2 + 340;
    int yloc = (sectionHeaderView.frame.size.height / 2) - (labelsize.height / 2);
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
    [nameLabel setText:labeltext];
    [nameLabel setFont:labelfont];
    [nameLabel setTextColor:labelcolor];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    
    [sectionHeaderView addSubview:nameLabel];
    
    xloc += 100;
    
    labeltext = @"# mål";
    labelsize = [labeltext sizeWithFont:labelfont];
    UILabel *goalsLabel = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
    [goalsLabel setText:labeltext];
    [goalsLabel setFont:labelfont];
    [goalsLabel setTextColor:labelcolor];
    [goalsLabel setBackgroundColor:[UIColor clearColor]];
    
    [sectionHeaderView addSubview:goalsLabel];
    
    xloc += 100;
    
    labeltext = @"# seiere";
    labelsize = [labeltext sizeWithFont:labelfont];
    UILabel *pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
    [pointsLabel setText:labeltext];
    [pointsLabel setFont:labelfont];
    [pointsLabel setTextColor:labelcolor];
    [pointsLabel setBackgroundColor:[UIColor clearColor]];
    
    [sectionHeaderView addSubview:pointsLabel];
    
    xloc += 80;
    
    labeltext = @"% seiere";
    labelsize = [labeltext sizeWithFont:labelfont];
    UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
    [percentLabel setText:labeltext];
    [percentLabel setFont:labelfont];
    [percentLabel setTextColor:labelcolor];
    [percentLabel setBackgroundColor:[UIColor clearColor]];
    
    [sectionHeaderView addSubview:percentLabel];
    
    xloc += 100;
    
    labeltext = @"% siste 5";
    labelsize = [labeltext sizeWithFont:labelfont];
    UILabel *lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
    [lastLabel setText:labeltext];
    [lastLabel setFont:labelfont];
    [lastLabel setTextColor:labelcolor];
    [lastLabel setBackgroundColor:[UIColor clearColor]];
    
    [sectionHeaderView addSubview:lastLabel];
    
    xloc += 120;
    
    labeltext = @"poeng";
    labelsize = [labeltext sizeWithFont:labelfont];
    UILabel *ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
    [ratingLabel setText:labeltext];
    [ratingLabel setFont:labelfont];
    [ratingLabel setTextColor:labelcolor];
    [ratingLabel setBackgroundColor:[UIColor clearColor]];
    
    [sectionHeaderView addSubview:ratingLabel];
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


#pragma mark - init methods

- (void)buildAndShowInterface
{
    pointsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    pointsTableView.delegate = self;
    pointsTableView.dataSource = self;
    [pointsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [pointsTableView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:pointsTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (void)showSingelPointOverview
{
    dataSource = [[AppModel getAppModel] getSinglePointsStatistics];
    
    [self buildAndShowInterface];
}

- (void)showTeamPointOverview
{
    dataSource = [[AppModel getAppModel] getTeamPointsStatistics];
    
    [self buildAndShowInterface];
}

@end
