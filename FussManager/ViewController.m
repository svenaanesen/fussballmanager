//
//  ViewController.m
//  FussballManager
//
//  Created by Sven Aanesen on 31.10.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import "ViewController.h"

#import "PlayerRegistrationViewController.h"
#import "MatchRegistrationViewController.h"
#import "AppModel.h"
#import "StatisticsViewController.h"

typedef enum {
    MenuButtonTypePlayer = 0,
    MenuButtonTypeMatch = 1,
    MenuButtonTypeStatistics = 2
} MenuButtonType;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // build interface
    CGRect infoframe;
    CGRect applicationframe = [UIScreen mainScreen].applicationFrame;
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
        infoframe = CGRectMake(0, 0, applicationframe.size.height, applicationframe.size.width);
    else
        infoframe = CGRectMake(0, 0, applicationframe.size.width, applicationframe.size.height);
    
    self.view.frame = infoframe;
    [[AppModel getAppModel] setDeviceSize:infoframe.size];
    
    // add background
    UIImage *background = [UIImage imageNamed:@"background.png"];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:background];
    [self.view addSubview:backgroundView];
    
    // add header title
    UIImage *titleimage = [UIImage imageNamed:@"headertitle.png"];
    UIImageView *titleimageView = [[UIImageView alloc] initWithImage:titleimage];
    CGRect titleframe = titleimageView.frame;
    titleframe.origin.x = (infoframe.size.width / 2) - (titleimage.size.width / 2);
    titleframe.origin.y = 90;
    titleimageView.frame = titleframe;
    [self.view addSubview:titleimageView];
    
    // add navigation buttons
    NSArray *buttonImages = [NSArray arrayWithObjects:@"button_newplayer.png", @"button_newmatch.png", @"button_statistics.png", nil];
    int xloc = infoframe.size.width / (buttonImages.count+1);
    for (int i=0; i < buttonImages.count; i++) {
        // build button
        UIImage *buttonImage = [UIImage imageNamed:[buttonImages objectAtIndex:i]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:buttonImage forState:UIControlStateNormal];
        [button setTag:i];
        button.frame = CGRectMake(xloc+(xloc * i)-(buttonImage.size.width/2),
                                  (infoframe.size.height/2) - (buttonImage.size.height / 2),
                                  buttonImage.size.width,
                                  buttonImage.size.height);
        
        [button addTarget:self action:@selector(menuButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
   [self setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menuButtonHandler:(id)sender
{
    int buttonType = [sender tag];
    if (buttonType == MenuButtonTypePlayer) {
        PlayerRegistrationViewController *playerRegistration = [[PlayerRegistrationViewController alloc] init];
        [playerRegistration setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        playerRegistration.view.frame = self.view.frame;
        [self presentViewController:playerRegistration animated:YES completion:^{
            [playerRegistration.view setUserInteractionEnabled:YES];
            NSLog(@"player show");
        }];
    
    } else if (buttonType == MenuButtonTypeMatch) {
        MatchRegistrationViewController *matchRegistration = [[MatchRegistrationViewController alloc] init];
        [matchRegistration setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        matchRegistration.view.frame = self.view.frame;
        [self presentViewController:matchRegistration animated:YES completion:^{
            [matchRegistration.view setUserInteractionEnabled:YES];
            NSLog(@"match show");
        }];
        
        
    } else if (buttonType == MenuButtonTypeStatistics) {
        StatisticsViewController *statisticsController = [[StatisticsViewController alloc] init];
        [statisticsController setModalTransitionStyle:UIModalTransitionStylePartialCurl];
        statisticsController.view.frame = self.view.frame;
        [self presentViewController:statisticsController animated:YES completion:^{
            [statisticsController.view setUserInteractionEnabled:YES];
            NSLog(@"statistics show");
        }];
    }
}

@end
