//
//  MatchRegistrationViewController.m
//  FussballManager
//
//  Created by Sven Aanesen on 05.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import "MatchRegistrationViewController.h"
#import "ConnectionManager.h"
#import "PlayerVO.h"
#import "MatchVO.h"
#import "AppModel.h"
#import "TeamVO.h"
#import "MatchScoreView.h"
#import "NotificationManager.h"
#import "SBJson.h"

#define kMainHeaderTag      33
#define kTeam1HeaderTag     34
#define kTeam2HeaderTag     35

#define kTeam1BackgroundTag     36
#define kTeam2BackgroundTag     37

#define kRegisterButton         38

@interface MatchRegistrationViewController ()

@end

@implementation MatchRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // add background
        UIImage *background = [UIImage imageNamed:@"background.png"];
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:background];
        [self setView:backgroundView];
        
        CGRect deviceframe = self.view.frame;
        deviceframe.size = [[AppModel getAppModel] deviceSize];
        self.view.frame = deviceframe;
        
        // add header title
        UIImage *titleimage = [UIImage imageNamed:@"headertitle_newmatch.png"];
        UIImageView *titleimageView = [[UIImageView alloc] initWithImage:titleimage];
        [titleimageView setTag:kMainHeaderTag];
        CGRect titleframe = titleimageView.frame;
        titleframe.origin.x = (self.view.frame.size.width / 2) - (titleimage.size.width / 2);
        titleframe.origin.y = 90;
        titleimageView.frame = titleframe;
        [self.view addSubview:titleimageView];
        
        // add match icon
        UIImage *matchIcon = [UIImage imageNamed:@"match.png"];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:matchIcon];
        CGRect iconframe = iconView.frame;
        iconframe.origin.x = (self.view.frame.size.width / 2) - (matchIcon.size.width / 2);
        iconframe.origin.y = (self.view.frame.size.height / 2) - (matchIcon.size.height / 2);
        iconView.frame = iconframe;
        [self.view addSubview:iconView];
        
        // prepare images for the rest of the view
        UIImage *pickerbackground = [UIImage imageNamed:@"background_playerpicker.png"];
        UIImage *teamOneHeader    = [UIImage imageNamed:@"header_teamone.png"];
        UIImage *teamTwoHeader    = [UIImage imageNamed:@"header_teamtwo.png"];
        UIImage *buttonimage      = [UIImage imageNamed:@"button_startmatch.png"];
        
        // add background images
        UIImageView *picker1View = [[UIImageView alloc] initWithImage:pickerbackground];
        [picker1View setTag:kTeam1BackgroundTag];
        CGRect picker1frame = picker1View.frame;
        picker1frame.origin.x = (self.view.frame.size.width / 2) - (buttonimage.size.width / 2) - 20 - pickerbackground.size.width;
        picker1frame.origin.y = (self.view.frame.size.height / 2) - (pickerbackground.size.height / 2) + (teamOneHeader.size.height*2);
        picker1View.frame = picker1frame;
        [self.view addSubview:picker1View];
        
        UIImageView *picker2View = [[UIImageView alloc] initWithImage:pickerbackground];
        [picker2View setTag:kTeam2BackgroundTag];
        CGRect picker2frame = picker2View.frame;
        picker2frame.origin.x = (self.view.frame.size.width / 2) + (buttonimage.size.width / 2) + 20;
        picker2frame.origin.y = picker1frame.origin.y;
        picker2View.frame = picker2frame;
        [self.view addSubview:picker2View];
        
        // header images
        UIImageView *header1view = [[UIImageView alloc] initWithImage:teamOneHeader];
        [header1view setTag:kTeam1HeaderTag];
        CGRect header1frame = header1view.frame;
        header1frame.origin.x = picker1frame.origin.x;
        header1frame.origin.y = picker1frame.origin.y - teamOneHeader.size.height;
        header1view.frame = header1frame;
        [self.view addSubview:header1view];
        
        UIImageView *header2view = [[UIImageView alloc] initWithImage:teamTwoHeader];
        [header2view setTag:kTeam2HeaderTag];
        CGRect header2frame = header2view.frame;
        header2frame.origin.x = picker2frame.origin.x;
        header2frame.origin.y = picker2frame.origin.y - teamTwoHeader.size.height;
        header2view.frame = header2frame;
        [self.view addSubview:header2view];
        
        // add register button
        UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [registerButton setTag:kRegisterButton];
        [registerButton setImage:buttonimage forState:UIControlStateNormal];
        [registerButton addTarget:self action:@selector(prepareMatch:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect buttonframe = registerButton.frame;
        buttonframe.origin.x = (self.view.frame.size.width / 2) - (buttonimage.size.width / 2);
        buttonframe.origin.y = picker1frame.origin.y + picker1frame.size.height - buttonimage.size.height + 2;
        buttonframe.size = buttonimage.size;
        registerButton.frame = buttonframe;
        [self.view addSubview:registerButton];
                
        // add close button
        UIImage *closeimage = [UIImage imageNamed:@"close.png"];
        UIButton *closebtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        [closebtnView setImage:closeimage forState:UIControlStateNormal];
        [closebtnView addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        
        buttonframe = closebtnView.frame;
        buttonframe.origin.x = self.view.frame.size.width - closeimage.size.width - 10;
        buttonframe.origin.y = 10;
        buttonframe.size = closeimage.size;
        closebtnView.frame = buttonframe;
        [self.view addSubview:closebtnView];
        
        // prepare datasource
        datasource = [NSArray arrayWithArray:[[AppModel getAppModel] players]];
        selectedPlayersTeam1 = [[NSMutableArray alloc] init];
        selectedPlayersTeam2 = [[NSMutableArray alloc] init];
        
        // add table views
        int paddingx = 4;
        int paddingy = 4;
        CGRect table1frame = CGRectMake(picker1frame.origin.x + paddingx, picker1frame.origin.y + paddingy, picker1frame.size.width-(paddingx*2), picker1frame.size.height-(paddingy*2));
        team1tableview = [[UITableView alloc] initWithFrame:table1frame style:UITableViewStylePlain];
        [team1tableview setDelegate:self];
        [team1tableview setDataSource:self];
        [team1tableview setBackgroundColor:[UIColor clearColor]];
        [team1tableview setAllowsMultipleSelection:YES];
        [self.view addSubview:team1tableview];
        
        CGRect table2frame = CGRectMake(picker2frame.origin.x + paddingx, picker2frame.origin.y + paddingy, picker2frame.size.width-(paddingx*2), picker2frame.size.height-(paddingy*2));
        team2tableview = [[UITableView alloc] initWithFrame:table2frame style:UITableViewStylePlain];
        [team2tableview setDelegate:self];
        [team2tableview setDataSource:self];
        [team2tableview setBackgroundColor:[UIColor clearColor]];
        [team2tableview setAllowsMultipleSelection:YES];
        [self.view addSubview:team2tableview];
        
        goalList = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
        
    }
    return self;
}

- (void)dismissView
{
    // dismiss the view
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismissed...");
    }];
}

- (void)prepareMatch:(id)sender
{
    // check wether this is a team match or a single match
    if ([selectedPlayersTeam1 count] != [selectedPlayersTeam2 count] || [selectedPlayersTeam1 count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Regler for kampoppsett" message:@"En kamp må enten være en mot en eller to mot to. Velg en eller to spillere på hver side og trykk deretter på Registrer" delegate:nil cancelButtonTitle:@"Den er grei!"otherButtonTitles:nil];
        [alert show];
        
        return; 
        
    } else {
        // correct amount of players selected - if team, register it
        if ([selectedPlayersTeam1 count] > 1) {
            // we are playing teams
            NSString *player1team1 = [(PlayerVO *)[selectedPlayersTeam1 objectAtIndex:0] id];
            NSString *player2team1 = [(PlayerVO *)[selectedPlayersTeam1 objectAtIndex:1] id];
            NSString *player1team2 = [(PlayerVO *)[selectedPlayersTeam2 objectAtIndex:0] id];
            NSString *player2team2 = [(PlayerVO *)[selectedPlayersTeam2 objectAtIndex:1] id];
            
            NSLog(@"######## Create game with team1: %@, %@     team2: %@, %@ ########", player1team1, player2team1, player1team2, player2team2);
            NSString *teamId1 = [[AppModel getAppModel] getTeamIdForTeamWithPlayers:[NSArray arrayWithObjects:player1team1, player2team1, nil]];
            NSString *teamId2 = [[AppModel getAppModel] getTeamIdForTeamWithPlayers:[NSArray arrayWithObjects:player1team2, player2team2, nil]];
            [self startMatchWithPlayersWithId:teamId1 andPlayerId:teamId2];
            
        } else {
            // one on one match - start it
            NSString *playerId1 = [(PlayerVO *)[selectedPlayersTeam1 objectAtIndex:0] id];
            NSString *playerId2 = [(PlayerVO *)[selectedPlayersTeam2 objectAtIndex:0] id];
            [self startMatchWithPlayersWithId:playerId1 andPlayerId:playerId2];
        }
        
    }
}

- (void)startMatchWithPlayersWithId:(NSString *)playerId1 andPlayerId:(NSString *)playerId2
{
    // save a new match to the appmodel for later registration
    MatchVO *newmatch = [[MatchVO alloc] init];
    [newmatch setUserid1:playerId1];
    [newmatch setUserid2:playerId2];
    
    NSLog(@"-------> %@ - %@", playerId1, playerId2);
    [[AppModel getAppModel] setActiveMatch:newmatch];
    
    // start by hiding views that shouldn't be used anymore
    [UIView animateWithDuration:0.5
                     animations:^{
                         // hide team tables
                         [team1tableview setAlpha:0.0];
                         [team2tableview setAlpha:0.0];
                         
                         // hide headers
                         [[[self view] viewWithTag:kMainHeaderTag] setAlpha:0.0];
                         [[[self view] viewWithTag:kTeam1HeaderTag] setAlpha:0.0];
                         [[[self view] viewWithTag:kTeam2HeaderTag] setAlpha:0.0];
                         
                         // hide backgrounds
                         [[[self view] viewWithTag:kTeam1BackgroundTag] setAlpha:0.0];
                         [[[self view] viewWithTag:kTeam2BackgroundTag] setAlpha:0.0];
                         
                         // hide button
                         [[[self view] viewWithTag:kRegisterButton] setAlpha:0.0];
                         
                     }
                     completion:^(BOOL finished) {
                         // hide team tables
                         [team1tableview removeFromSuperview];
                         [team2tableview removeFromSuperview];
                         
                         // hide headers
                         [[[self view] viewWithTag:kMainHeaderTag] removeFromSuperview];
                         [[[self view] viewWithTag:kTeam1HeaderTag] removeFromSuperview];
                         [[[self view] viewWithTag:kTeam2HeaderTag] removeFromSuperview];
                         
                         // hide buttons
                         //[[[self view] viewWithTag:kRegisterButton] removeFromSuperview];
                         
                         // build new interface
                         [self buildMatchInterface];
                     }];
}

- (void)registerMatchResults:(id)sender
{
    MatchVO *currentMatch = [[AppModel getAppModel] activeMatch];
    [currentMatch setGoals1:[NSNumber numberWithInt:goalsTeam1]];
    [currentMatch setGoals2:[NSNumber numberWithInt:goalsTeam2]];
    
    // register match
    NSString *activeMatchId = [[ConnectionManager getInstance] addMatchWithPlayerOneId:[currentMatch userid1]
                                              andPlayerTwoId:[currentMatch userid2]
                                         withPlayerOnePoints:goalsTeam1
                                          andPlayerTwoPoints:goalsTeam2];
    
    [currentMatch setId:activeMatchId];
    
    // save individual match results
    int pointsPlayer1 = ([[currentMatch goals1] intValue] > [[currentMatch goals2] intValue]) ? 1 : 0;
    int pointsPlayer2 = ([[currentMatch goals2] intValue] > [[currentMatch goals1] intValue]) ? 1 : 0;
    [[ConnectionManager getInstance] addResultsForUserId:[currentMatch userid1]
                                              withPoints:pointsPlayer1
                                                andGoals:[[currentMatch goals1] intValue]
                                    playingInMatchWithId:[currentMatch id]];
    
    [[ConnectionManager getInstance] addResultsForUserId:[currentMatch userid2]
                                              withPoints:pointsPlayer2
                                                andGoals:[[currentMatch goals2] intValue]
                                    playingInMatchWithId:[currentMatch id]];
    
    [self dismissView];
}


#pragma mark - Match action interface and handling

- (void)buildMatchInterface
{
    // add score boards
    CGRect scoreframe1 = CGRectMake([self.view viewWithTag:kTeam1BackgroundTag].frame.origin.x,
                                    (self.view.frame.size.height/2)-([self.view viewWithTag:kTeam1BackgroundTag].frame.size.height/2),
                                    [self.view viewWithTag:kTeam1BackgroundTag].frame.size.width,
                                    [self.view viewWithTag:kTeam1BackgroundTag].frame.size.height/2);
    team1scoreboard = [[UIPickerView alloc] initWithFrame:scoreframe1];
    team1scoreboard.backgroundColor = [UIColor clearColor];
    team1scoreboard.delegate = self;
    team1scoreboard.dataSource = self;
    [self.view addSubview:team1scoreboard];
    
    CGRect scoreframe2 = CGRectMake([self.view viewWithTag:kTeam2BackgroundTag].frame.origin.x,
                                    (self.view.frame.size.height/2)-(([self.view viewWithTag:kTeam2BackgroundTag].frame.size.height/2)),
                                    [self.view viewWithTag:kTeam2BackgroundTag].frame.size.width,
                                    [self.view viewWithTag:kTeam2BackgroundTag].frame.size.height/2);
    team2scoreboard = [[UIPickerView alloc] initWithFrame:scoreframe2];
    team2scoreboard.backgroundColor = [UIColor clearColor];
    team2scoreboard.delegate = self;
    team2scoreboard.dataSource = self;
    [self.view addSubview:team2scoreboard];
    
    // add scoreboard titles
    NSString *player1string;
    NSString *player2string;
    BaseValueObject *player1 = [[AppModel getAppModel] getPlayerWithId:[[[AppModel getAppModel] activeMatch] userid1]];
    BaseValueObject *player2 = [[AppModel getAppModel] getPlayerWithId:[[[AppModel getAppModel] activeMatch] userid2]];
    if ([player1 isKindOfClass:[PlayerVO class]]) {
        // this is a one-on-one match
        player1string = [(PlayerVO *)player1 name];
        player2string = [(PlayerVO *)player2 name];
        
    } else {
        // this is a team match
        player1string = [(TeamVO *)player1 teamname];
        player2string = [(TeamVO *)player2 teamname];
    }
    
    UIFont  *labelFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40];
    CGSize   labelsize = [player1string sizeWithFont:labelFont];
    
    UILabel *team1label = [[UILabel alloc] initWithFrame:CGRectMake(team1scoreboard.frame.origin.x,
                                                                    team1scoreboard.frame.origin.y - labelsize.height,
                                                                    team1scoreboard.frame.size.width,
                                                                    labelsize.height)];
    [team1label setBackgroundColor:[UIColor clearColor]];
    [team1label setFont:labelFont];
    [team1label setText:player1string];
    NSLog(@"-> Add team/player: %@", player1string);
    [team1label setTextColor:[UIColor whiteColor]];
    [team1label setTextAlignment:NSTextAlignmentCenter];
    [team1label setAdjustsFontSizeToFitWidth:YES];
    [self.view addSubview:team1label];
    
    UILabel *team2label = [[UILabel alloc] initWithFrame:CGRectMake(team2scoreboard.frame.origin.x,
                                                                    team2scoreboard.frame.origin.y - labelsize.height,
                                                                    team2scoreboard.frame.size.width,
                                                                    labelsize.height)];
    [team2label setBackgroundColor:[UIColor clearColor]];
    [team2label setFont:labelFont];
    [team2label setText:player2string];
    NSLog(@"-> Add team/player: %@", player2string);
    [team2label setTextColor:[UIColor whiteColor]];
    [team2label setTextAlignment:NSTextAlignmentCenter];
    [team2label setAdjustsFontSizeToFitWidth:YES];
    [self.view addSubview:team2label];
    
    // add register match button
    UIImage *registerImage = [UIImage imageNamed:@"button_register"];
    UIButton *registerMatchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerMatchButton setImage:registerImage forState:UIControlStateNormal];
    [registerMatchButton addTarget:self action:@selector(registerMatchResults:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize deviceSize = [[AppModel getAppModel] deviceSize];
    CGRect buttonframe = registerMatchButton.frame;
    buttonframe.origin.x = (deviceSize.width / 2) - (registerImage.size.width / 2);
    buttonframe.origin.y = team1scoreboard.frame.origin.y + team1scoreboard.frame.size.height + 20;
    buttonframe.size = registerImage.size;
    registerMatchButton.frame = buttonframe;
    [self.view addSubview:registerMatchButton];
}


#pragma mark - Picker view datasource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 11;
}


#pragma mark - Picker view delegate methods

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return pickerView.frame.size.height;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return pickerView.frame.size.width-10;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *goalString = [goalList objectAtIndex:row];
    
    MatchScoreView *scoreView = [[MatchScoreView alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, pickerView.frame.size.height) andValue:goalString];
    return scoreView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == team1scoreboard) {
        goalsTeam1 = [[goalList objectAtIndex:row] intValue];
        
    } else {
        goalsTeam2 = [[goalList objectAtIndex:row] intValue];
    }
}



#pragma mark - Table View Datasource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PlayerCell"];
        [[cell textLabel] setFont:[UIFont fontWithName:@"HelveticeNeue" size:18]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    // add content
    PlayerVO *player = (PlayerVO *)[datasource objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[player name]];
    [[cell detailTextLabel] setText:[player department]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return datasource.count;
}

#pragma mark - Table View Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL playeroverload = NO;
    if (tableView == team1tableview) {
        // team player added for team 1
        if ([selectedPlayersTeam1 count] == 2)
            playeroverload = YES;
        else
            [selectedPlayersTeam1 addObject:[datasource objectAtIndex:indexPath.row]];
        
    } else {
        // team player added for team 2
        if ([selectedPlayersTeam2 count] == 2)
            playeroverload = YES;
        else
            [selectedPlayersTeam2 addObject:[datasource objectAtIndex:indexPath.row]];
    }
    
    if (playeroverload) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"For mange spillere" message:@"Det kan ikke registreres et lagspill med flere enn 2 spillere på hvert lag" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerVO *player = (PlayerVO *)[datasource objectAtIndex:indexPath.row];
    if (tableView == team1tableview) {
        for (int i=0; i < selectedPlayersTeam1.count; i++) {
            if ([[player id] floatValue] == [[(PlayerVO *)[selectedPlayersTeam1 objectAtIndex:i] id] floatValue]) {
                [selectedPlayersTeam1 removeObjectAtIndex:i];
                break;
            }
        }
    
    } else {
        for (int i=0; i < selectedPlayersTeam2.count; i++) {
            if ([[player id] floatValue] == [[(PlayerVO *)[selectedPlayersTeam2 objectAtIndex:i] id] floatValue]) {
                [selectedPlayersTeam2 removeObjectAtIndex:i];
                break;
            }
        }
    }
}

@end
