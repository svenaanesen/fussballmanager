//
//  StatisticsViewController.m
//  FussManager
//
//  Created by Sven Aanesen on 07.01.13.
//  Copyright (c) 2013 Eniro. All rights reserved.
//

#import "StatisticsViewController.h"
#import "AppModel.h"
#import "ApplicationConstants.h"
#import "NotificationManager.h"
#import "ConnectionManager.h"
#import "PointsResultsView.h"

#import "MatchesView.h"

@interface StatisticsViewController ()

@end

@implementation StatisticsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // build interface
        CGRect deviceframe = self.view.frame;
        deviceframe.size = [[AppModel getAppModel] deviceSize];
        self.view.frame = deviceframe;
        
        // add background
        UIImage *background = [UIImage imageNamed:@"background.png"];
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:background];
        [self setView:backgroundView];
        
        // add header title
        int yloc = 90;
        NSString *headerString = @"Kampoversikt";
        UIFont   *headerFont = [UIFont fontWithName:APPLICATION_FONT size:APPLICATION_FONT_HEADER_SIZE];
        CGSize    headerSize = [headerString sizeWithFont:headerFont];
        UILabel  *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - (headerSize.width / 2), yloc, headerSize.width, headerSize.height)];
        [headerLabel setBackgroundColor:[UIColor clearColor]];
        [headerLabel setText:headerString];
        [headerLabel setFont:headerFont];
        [headerLabel setTextColor:[UIColor whiteColor]];
        headerLabel.shadowColor = [UIColor colorWithWhite:0.1 alpha:0.9];
        headerLabel.shadowOffset = CGSizeMake(1, 2);
        [self.view addSubview:headerLabel];
        
        yloc += headerLabel.frame.size.height + 20;
        
        // add navigation bar
        NSArray *segments = [NSArray arrayWithObjects:@"Singelkamper", @"Teamkamper", @"Poengoversikt Singel", @"Poengoversikt Team", nil];
        navigationBar = [[UISegmentedControl alloc] initWithItems:segments];
        [navigationBar setSegmentedControlStyle:UISegmentedControlStyleBordered];
        [navigationBar addTarget:self action:@selector(navigationBarSegmentSelectedHandler:) forControlEvents:UIControlEventValueChanged];
        CGRect navframe = navigationBar.frame;
        navframe.origin.y = yloc;
        navframe.size.width = self.view.frame.size.width * 0.8;
        navframe.origin.x = (self.view.frame.size.width / 2) - (navframe.size.width / 2);
        navigationBar.frame = navframe;
        [self.view addSubview:navigationBar];
        
        yloc += navigationBar.frame.size.height + 20;
        
        statisticsViewYLoc = yloc;
        
        // wait for updated results and matches
        [[NotificationManager getInstance] addListener:self selector:@selector(allResultsCollectedSuccessfully) listenerType:NotificationAllResultsRecieved];
        [[NotificationManager getInstance] addListener:self selector:@selector(allMatchesCollectedSuccessfully) listenerType:NotificationAllMatchesRecieved];
        
        // start collecting data - get all match data
        [[ConnectionManager getInstance] getAllMatches];
        
        // get all results
        [[ConnectionManager getInstance] getAllResults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkForReadyness
{
    if (resultsRecieved && matchesRecieved) {
        // let's go!  Start with first nav bar selected
        [navigationBar setSelectedSegmentIndex:0];
        [self navigationBarSegmentSelectedHandler:navigationBar];
    }
}

#pragma mark - segmented bar handler

- (void)navigationBarSegmentSelectedHandler:(id)sender
{
    if (activeView) {
        [activeView removeFromSuperview];
        activeView = nil;
    }
    
    if (statisticsRect.size.width == 0)
        statisticsRect = CGRectMake(0, statisticsViewYLoc, self.view.frame.size.width, self.view.frame.size.height - statisticsViewYLoc);
        
    if (navigationBar.selectedSegmentIndex == 0) {
        // single matches selected
        MatchesView *matches = [[MatchesView alloc] initWithFrame:statisticsRect];
        [matches showSingelMatches];
        [self.view addSubview:matches];
        
        
        activeView = matches;
        
    } else  if (navigationBar.selectedSegmentIndex == 1) {
        // team matches selected
        MatchesView *matches = [[MatchesView alloc] initWithFrame:statisticsRect];
        [matches showTeamMatches];
        [self.view addSubview:matches];
        
        activeView = matches;
        
    } else  if (navigationBar.selectedSegmentIndex == 2) {
        // points overview selected
        PointsResultsView *points = [[PointsResultsView alloc] initWithFrame:statisticsRect];
        [points showSingelPointOverview];
        [self.view addSubview:points];
        
        activeView = points;
        
    } else  if (navigationBar.selectedSegmentIndex == 3) {
        // points overview selected
        PointsResultsView *points = [[PointsResultsView alloc] initWithFrame:statisticsRect];
        [points showTeamPointOverview];
        [self.view addSubview:points];
        
        activeView = points;
        
    }
}


#pragma mark - notification handlers

- (void)allResultsCollectedSuccessfully
{
    [[NotificationManager getInstance] removeListener:self listenerType:NotificationAllResultsRecieved];

    resultsRecieved = YES;
    
    [self checkForReadyness];
}

- (void)allMatchesCollectedSuccessfully
{
    [[NotificationManager getInstance] removeListener:self listenerType:NotificationAllMatchesRecieved];
    
    matchesRecieved = YES;
    
    [self checkForReadyness];
}


@end
