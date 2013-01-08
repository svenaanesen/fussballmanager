//
//  MatchTableViewCell.m
//  FussManager
//
//  Created by Sven Aanesen on 07.01.13.
//  Copyright (c) 2013 Eniro. All rights reserved.
//

#import "MatchTableViewCell.h"

#import "ApplicationConstants.h"
#import "AppModel.h"


@implementation MatchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        // Initialization code
        UIFont *cellfont = [UIFont fontWithName:APPLICATION_FONT_NORMAL size:26];
        UIColor *cellcolor = [UIColor whiteColor];
        
        int cellsize = self.frame.size.width / 5;
        int xloc = cellsize;
        int yloc = 0;
        
        // add date label
        NSString *labelstring = @"88.88.8888";
        CGSize    labelsize = [labelstring sizeWithFont:cellfont];
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
        [dateLabel setFont:cellfont];
        [dateLabel setTextColor:cellcolor];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:dateLabel];
        
        xloc += cellsize;
        
        // add user 1 label
        labelstring = @"Fullt Navn og kanskje Teamnavn";
        labelsize = [labelstring sizeWithFont:cellfont];
        user1Label = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
        [user1Label setFont:cellfont];
        [user1Label setTextColor:cellcolor];
        [user1Label setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:user1Label];
        
        xloc += cellsize;
        
        // add user 1 label
        user2Label = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
        [user2Label setFont:cellfont];
        [user2Label setTextColor:cellcolor];
        [user2Label setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:user2Label];
        
        xloc += cellsize;
        
        // add results
        labelstring = @"10 -";
        labelsize = [labelstring sizeWithFont:cellfont];
        result1Label = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
        [result1Label setFont:cellfont];
        [result1Label setTextColor:cellcolor];
        [result1Label setBackgroundColor:[UIColor clearColor]];
        [result1Label setTextAlignment:NSTextAlignmentRight];
        
        [self addSubview:result1Label];
        
        xloc += cellsize;
        
        // add results
        labelstring = @"10";
        labelsize = [labelstring sizeWithFont:cellfont];
        result2Label = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
        [result2Label setFont:cellfont];
        [result2Label setTextColor:cellcolor];
        [result2Label setBackgroundColor:[UIColor clearColor]];
        [result2Label setTextAlignment:NSTextAlignmentLeft];
        
        [self addSubview:result2Label];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setCellContent:(MatchVO *)matchinfo
{
    // add date info
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yy"];
    
    NSString *datestring = [dateFormatter stringFromDate:[matchinfo date]];
    [dateLabel setText:datestring];
    
    // add user 1 name
    NSString *userName1 = [[AppModel getAppModel] getUserNameForId:[matchinfo userid1]];
    if (userName1 == nil)
        userName1 = [[AppModel getAppModel] getTeamNameForId:[matchinfo userid1]];
    [user1Label setText:userName1];
    
    // add user 2 name
    NSString *userName2 = [[AppModel getAppModel] getUserNameForId:[matchinfo userid2]];
    if (userName2 == nil)
        userName2 = [[AppModel getAppModel] getTeamNameForId:[matchinfo userid2]];
    [user2Label setText:userName2];
    
    // add results
    NSString *results1 = [NSString stringWithFormat:@"%i -", [[matchinfo goals1] intValue]];
    [result1Label setText:results1];
    
    NSString *results2 = [NSString stringWithFormat:@"%i", [[matchinfo goals2] intValue]];
    [result2Label setText:results2];
    
    if ([[matchinfo goals1] intValue] > [[matchinfo goals2] intValue]) {
        [user1Label setTextColor:[UIColor yellowColor]];
        [user2Label setTextColor:[UIColor whiteColor]];
        
    } else {
        [user1Label setTextColor:[UIColor whiteColor]];
        [user2Label setTextColor:[UIColor yellowColor]];
    }
    
    
    // adjust origin for all cell items
    int xloc = (self.frame.size.width - (self.frame.size.width * 0.8)) / 2 + 10;
    
    CGRect frame = dateLabel.frame;
    frame.origin.x = xloc;
    dateLabel.frame = frame;
    
    xloc += 150;
    
    frame = user1Label.frame;
    frame.origin.x = xloc;
    user1Label.frame = frame;
    
    xloc += 280;
    
    frame = user2Label.frame;
    frame.origin.x = xloc;
    user2Label.frame = frame;
    
    xloc += 280;
    
    frame = result1Label.frame;
    frame.origin.x = xloc;
    result1Label.frame = frame;
    
    xloc += 55;
    
    frame = result2Label.frame;
    frame.origin.x = xloc;
    result2Label.frame = frame;
    
}

@end
