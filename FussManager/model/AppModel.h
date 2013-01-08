//
//  AppModel.h
//  FussballManager
//
//  Created by Sven Aanesen on 01.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatchVO.h"
#import "PlayerVO.h"

@interface AppModel : NSObject

@property (strong) NSArray *players;
@property (strong) NSArray *matches;
@property (strong) NSArray *teams;
@property (strong) NSArray *results;
@property (strong) MatchVO *activeMatch;

@property (readwrite) CGSize deviceSize;



+ (AppModel *)getAppModel;

- (void)parseAndSetPlayers:(NSString *)allplayers;

- (void)parseAndSetTeams:(NSString *)allteams;

- (void)parseAndSetMatches:(NSString *)allmatches;

- (void)parseAndSetResults:(NSString *)allresults;

- (id)getPlayerWithId:(NSString *)playerId;

- (NSString *)getTeamIdForTeamWithPlayers:(NSArray *)playerlist;



- (NSArray *)getAllSingelMatches;

- (NSArray *)getAllTeamMatches;

- (NSString *)getUserNameForId:(NSString *)userid;

- (NSString *)getTeamNameForId:(NSString *)teamid;

- (NSArray *)getSinglePointsStatistics;

- (NSArray *)getTeamPointsStatistics;

@end
