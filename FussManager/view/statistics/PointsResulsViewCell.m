//
//  PointsResulsViewCell.m
//  FussManager
//
//  Created by Sven Aanesen on 07.01.13.
//  Copyright (c) 2013 Eniro. All rights reserved.
//

#import "PointsResulsViewCell.h"

#import "AppModel.h"
#import "ApplicationConstants.h"

@implementation PointsResulsViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        // Initialization code
        UIFont *cellfont = [UIFont fontWithName:APPLICATION_FONT_NORMAL size:26];
        UIColor *cellcolor = [UIColor whiteColor];
        
        int cellsize = self.frame.size.width / 6;
        int xloc = cellsize;
        int yloc = 0;
        
        // add date label
        NSString *labelstring = @"Fullt Navn og kanskje Teamnavn";
        CGSize    labelsize = [labelstring sizeWithFont:cellfont];
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
        [nameLabel setFont:cellfont];
        [nameLabel setTextColor:cellcolor];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:nameLabel];
        
        xloc += cellsize;
        
        // add user 1 label
        labelstring = @"1000.00";
        labelsize = [labelstring sizeWithFont:cellfont];
        matchLabel = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
        [matchLabel setFont:cellfont];
        [matchLabel setTextColor:cellcolor];
        [matchLabel setBackgroundColor:[UIColor clearColor]];
        [matchLabel setTextAlignment:NSTextAlignmentRight];
        
        [self addSubview:matchLabel];
        
        xloc += cellsize;
        
        // add user 1 label
        goalsLabel = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
        [goalsLabel setFont:cellfont];
        [goalsLabel setTextColor:cellcolor];
        [goalsLabel setBackgroundColor:[UIColor clearColor]];
        [goalsLabel setTextAlignment:NSTextAlignmentRight];
        
        [self addSubview:goalsLabel];
        
        xloc += cellsize;
        
        // add user 1 label
        pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
        [pointsLabel setFont:cellfont];
        [pointsLabel setTextColor:cellcolor];
        [pointsLabel setBackgroundColor:[UIColor clearColor]];
        [pointsLabel setTextAlignment:NSTextAlignmentRight];
        
        [self addSubview:pointsLabel];
        
        xloc += cellsize;
        
        // add user 1 label
        totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
        [totalLabel setFont:cellfont];
        [totalLabel setTextColor:cellcolor];
        [totalLabel setBackgroundColor:[UIColor clearColor]];
        [totalLabel setTextAlignment:NSTextAlignmentRight];
        
        [self addSubview:totalLabel];
        
        xloc += cellsize;
        
        // add user 1 label
        lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
        [lastLabel setFont:cellfont];
        [lastLabel setTextColor:cellcolor];
        [lastLabel setBackgroundColor:[UIColor clearColor]];
        [lastLabel setTextAlignment:NSTextAlignmentRight];
        
        [self addSubview:lastLabel];
        
        xloc += cellsize;
        
        // add rating points
        ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(xloc, yloc, labelsize.width, labelsize.height)];
        [ratingLabel setFont:cellfont];
        [ratingLabel setTextColor:[UIColor yellowColor]];
        [ratingLabel setBackgroundColor:[UIColor clearColor]];
        [ratingLabel setTextAlignment:NSTextAlignmentRight];
        
        [self addSubview:ratingLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setCellContent:(StatisticsVO *)statistics
{
    // insert player/team name
    [nameLabel setText:[statistics name]];
    
    // insert match number
    [matchLabel setText:[NSString stringWithFormat:@"%i", [statistics totalgames]]];
    
    // insert goals number
    [goalsLabel setText:[NSString stringWithFormat:@"%i", [statistics totalgoals]]];
    
    // insert points number
    [pointsLabel setText:[NSString stringWithFormat:@"%i", [statistics totalpoints]]];
    
    // insert points number
    [lastLabel setText:[NSString stringWithFormat:@"%.1f", [statistics lastpoints]]];
    
    // insert points number
    [ratingLabel setText:[NSString stringWithFormat:@"%.0f", [statistics ratingpoints]]];
    
    // insert match number
    NSNumber *points = [NSNumber numberWithDouble:[statistics totalpoints]];
    NSNumber *matches = [NSNumber numberWithDouble:[statistics totalgames]];
    
    double matchPercent = ([points doubleValue] / [matches doubleValue]) * 100;
    [totalLabel setText:[NSString stringWithFormat:@"%.1f", matchPercent]];
    
    // adjust origin for all cell items
    int xloc = (self.frame.size.width - (self.frame.size.width * 0.8)) / 2 + 10;
    
    CGRect frame = nameLabel.frame;
    frame.origin.x = xloc;
    nameLabel.frame = frame;
    
    xloc += 280;
    
    frame = matchLabel.frame;
    frame.origin.x = xloc;
    matchLabel.frame = frame;
    
    xloc += 100;
    
    frame = goalsLabel.frame;
    frame.origin.x = xloc;
    goalsLabel.frame = frame;
    
    xloc += 100;
    
    frame = pointsLabel.frame;
    frame.origin.x = xloc;
    pointsLabel.frame = frame;
    
    xloc += 100;
    
    frame = totalLabel.frame;
    frame.origin.x = xloc;
    totalLabel.frame = frame;
    
    xloc += 100;
    
    frame = lastLabel.frame;
    frame.origin.x = xloc;
    lastLabel.frame = frame;
    
    xloc += 100;
    
    frame = ratingLabel.frame;
    frame.origin.x = xloc;
    ratingLabel.frame = frame;
}

@end
