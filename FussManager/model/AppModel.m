//
//  AppModel.m
//  FussballManager
//
//  Created by Sven Aanesen on 01.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import "AppModel.h"
#import "SBJson.h"
#import "TeamVO.h"
#import "ResultVO.h"
#import "ConnectionManager.h"
#import "StatisticsVO.h"

@implementation AppModel


+ (AppModel *)getAppModel
{
    static AppModel *appModel;
    @synchronized(self) {
        if (!appModel) {
            appModel = [[AppModel alloc] init];
        }
    }
    return appModel;
}


#pragma mark - parse and save data locally

- (void)parseAndSetPlayers:(NSString *)allplayers
{
    NSDictionary *unparsedPlayers = [allplayers JSONValue];
    if ([unparsedPlayers objectForKey:@"dbconnection"]) {
        
        NSDictionary *unparsedResults = (NSDictionary *)[unparsedPlayers objectForKey:@"dbconnection"];
        // connection from db returned - check for results
        if ([unparsedResults objectForKey:@"results"]) {
            // results from db returned
            if ([[unparsedResults objectForKey:@"results"] isKindOfClass:[NSArray class]]) {
                // parse all results
                NSMutableArray *parsedPlayers = [[NSMutableArray alloc] init];
                NSArray *results = (NSArray *)[unparsedResults objectForKey:@"results"];
                for (int i=0; i < results.count; i++) {
                    PlayerVO *player = [[PlayerVO alloc] initWithInfo:[results objectAtIndex:i]];
                    [parsedPlayers addObject:player];
                }
                
                // add parsed results to appmodel param
                [self setPlayers:parsedPlayers];
            }
        }
    }
}


- (void)parseAndSetTeams:(NSString *)allteams
{
    NSDictionary *unparsedTeams = [allteams JSONValue];
    if ([unparsedTeams objectForKey:@"dbconnection"]) {
        
        NSDictionary *unparsedResults = (NSDictionary *)[unparsedTeams objectForKey:@"dbconnection"];
        // connection from db returned - check for results
        if ([unparsedResults objectForKey:@"results"]) {
            // results from db returned
            if ([[unparsedResults objectForKey:@"results"] isKindOfClass:[NSArray class]]) {
                // parse all results
                NSMutableArray *parsedTeams = [[NSMutableArray alloc] init];
                NSArray *results = (NSArray *)[unparsedResults objectForKey:@"results"];
                for (int i=0; i < results.count; i++) {
                    TeamVO *team = [[TeamVO alloc] initWithInfo:[results objectAtIndex:i]];
                    [parsedTeams addObject:team];
                }
                
                // add parsed results to appmodel param
                [self setTeams:parsedTeams];
            }
        }
    }
}


- (void)parseAndSetMatches:(NSString *)allmatches
{
    NSDictionary *unparsedMatches = [allmatches JSONValue];
    if ([unparsedMatches objectForKey:@"dbconnection"]) {
        
        NSDictionary *unparsedResults = (NSDictionary *)[unparsedMatches objectForKey:@"dbconnection"];
        // connection from db returned - check for results
        if ([unparsedResults objectForKey:@"results"]) {
            // results from db returned
            if ([[unparsedResults objectForKey:@"results"] isKindOfClass:[NSArray class]]) {
                // parse all results
                NSMutableArray *parsedMatches = [[NSMutableArray alloc] init];
                NSArray *results = (NSArray *)[unparsedResults objectForKey:@"results"];
                for (int i=0; i < results.count; i++) {
                    MatchVO *match = [[MatchVO alloc] initWithInfo:[results objectAtIndex:i]];
                    [parsedMatches addObject:match];
                }
                
                // add parsed results to appmodel param
                [self setMatches:parsedMatches];
            }
        }
    }
}

- (void)parseAndSetResults:(NSString *)allresultsdata
{
    NSDictionary *unparsedResultsData = [allresultsdata JSONValue];
    if ([unparsedResultsData objectForKey:@"dbconnection"]) {
        
        NSDictionary *unparsedResults = (NSDictionary *)[unparsedResultsData objectForKey:@"dbconnection"];
        // connection from db returned - check for results
        if ([unparsedResults objectForKey:@"results"]) {
            // results from db returned
            if ([[unparsedResults objectForKey:@"results"] isKindOfClass:[NSArray class]]) {
                // parse all results
                NSMutableArray *parsedResults = [[NSMutableArray alloc] init];
                NSArray *results = (NSArray *)[unparsedResults objectForKey:@"results"];
                for (int i=0; i < results.count; i++) {
                    ResultVO *result = [[ResultVO alloc] initWithInfo:[results objectAtIndex:i]];
                    [parsedResults addObject:result];
                }
                
                // add parsed results to appmodel param
                [self setResults:parsedResults];
            }
        }
    }
}

#pragma mark - get locally saved data

- (id)getPlayerWithId:(NSString *)playerId
{
    if (_players) {
        for (int i=0; i < [_players count]; i++) {
            PlayerVO *player = [_players objectAtIndex:i];
            if ([[player id] isEqualToString:playerId]) {
                return player;
            }
        }
    }
    
    if (_teams) {
        for (int i=0; i < [_teams count]; i++) {
            TeamVO *team = [_teams objectAtIndex:i];
            if ([[team id] isEqualToString:playerId]) {
                return team;
            }
        }
    }
    return nil;
}

- (id)getSinglePlayerWithId:(NSString *)playerId
{
    if (_players) {
        for (int i=0; i < [_players count]; i++) {
            PlayerVO *player = [_players objectAtIndex:i];
            if ([[player id] isEqualToString:playerId]) {
                return player;
            }
        }
    }
    
    return nil;
}

- (id)getTeamPlayersWithId:(NSString *)playerId
{
    if (_teams) {
        for (int i=0; i < [_teams count]; i++) {
            TeamVO *team = [_teams objectAtIndex:i];
            if ([[team id] isEqualToString:playerId]) {
                return team;
            }
        }
    }
    
    return nil;
}

- (NSString *)getTeamIdForTeamWithPlayers:(NSArray *)playerlist
{
    if (_teams) {
        for (int i=0; i < [_teams count]; i++) {
            TeamVO *team = [_teams objectAtIndex:i];
            // check wether this team contains the defined players
            int usersFound = 0;
            for (int u=0; u < playerlist.count; u++) {
                if ([[team userid1] isEqualToString:[playerlist objectAtIndex:u]])
                    usersFound++;
                
                if ([[team userid2] isEqualToString:[playerlist objectAtIndex:u]])
                    usersFound++;
            }
            
            if (usersFound == playerlist.count)
                return [team id];
            
        }
    }
    
    // no team found for this combination of users - create a new team
    PlayerVO *player1 = [self getPlayerWithId:[playerlist objectAtIndex:0]];
    PlayerVO *player2 = [self getPlayerWithId:[playerlist objectAtIndex:1]];
    NSString *teamName = [NSString stringWithFormat:@"%@ / %@", [player1 name], [player2 name]];
    NSString *teamId = [[ConnectionManager getInstance] addTeamWithName:teamName withPlayerOneId:[player1 id] andPlayerTwoId:[player2 id]];
    
    // register the team locally as well
    TeamVO *newTeam = [[TeamVO alloc] init];
    [newTeam setId:teamId];
    [newTeam setUserid1:[player1 id]];
    [newTeam setUserid2:[player2 id]];
    [newTeam setTeamname:teamName];
    
    if ([_teams count] == 0) {
        [self setTeams:[NSArray arrayWithObject:newTeam]];
    } else {
        NSMutableArray *newTeamArray = [NSMutableArray arrayWithArray:_teams];
        [newTeamArray addObject:newTeam];
        [self setTeams:newTeamArray];
    }
    
    return teamId;
}

#pragma mark - Organize and return saved data from collected db source

- (NSArray *)getAllSingelMatches
{
    NSMutableArray *singlematches = [[NSMutableArray alloc] init];
    
    for (MatchVO *match in _matches) {
        NSString *username = [self getUserNameForId:[match userid1]];
        if (username != nil) {
            // this is a single match - add to list
            [singlematches addObject:match];
        }
    }
    
    return singlematches;
}

- (NSArray *)getAllTeamMatches
{
    NSMutableArray *teammatches = [[NSMutableArray alloc] init];
    
    for (MatchVO *match in _matches) {
        NSString *teamname = [self getTeamNameForId:[match userid1]];
        if (teamname != nil) {
            // this is a single match - add to list
            [teammatches addObject:match];
        }
    }
    
    return teammatches;
}


- (NSString *)getUserNameForId:(NSString *)userid
{
    for (PlayerVO *player in _players) {
        if ([[player id] isEqualToString:userid]) {
            return [player name];
        }
    }
    
    return nil;
}


- (NSString *)getTeamNameForId:(NSString *)teamid
{
    for (TeamVO *team in _teams) {
        if ([[team id] isEqualToString:teamid]) {
            return [team teamname];
        }
    }
    
    return nil;
}

- (NSArray *)getSinglePointsStatistics
{
    // reset player rating score
    for (PlayerVO *player in _players) {
        [player setRating:[NSNumber numberWithDouble:500]];
    }
    
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for (PlayerVO *player in _players) {
        StatisticsVO *statistics = [[StatisticsVO alloc] init];
        [statistics setId:[player id]];
        [statistics setName:[self getUserNameForId:[player id]]];
        [statistics setTotalgames:0];
        [statistics setTotalgoals:0];
        [statistics setTotalpoints:0];
        [statistics setRatingpoints:0];
        
        // loop through results and find all registered results for this user
        for (ResultVO *result in _results) {
            if ([[result userid] isEqualToString:[player id]]) {
                statistics.totalgames++;
                statistics.totalgoals += [[result goals] intValue];
                statistics.totalpoints += [[result points] intValue];
            }
        }
        
        // loop through matches to find countergoals
        NSMutableArray *lastMatches = [NSMutableArray new];
        for (MatchVO *match in _matches) {
            // find countergoals and to find the last 5 matches
            if ([[match userid1] isEqualToString:[player id]] || [[match userid2] isEqualToString:[player id]]) {
                // add match to last matchlist
                [lastMatches addObject:match];
                
                if ([[match userid1] isEqualToString:[player id]])
                    statistics.totalgoals -= [[match goals2] intValue];
                else
                    statistics.totalgoals -= [[match goals1] intValue];
            }
        }
        
        int numLastMatches = 0;
        int numLastPoints = 0;
        for (int i=lastMatches.count-1; i >= 0; i--) {
            MatchVO *match = [lastMatches objectAtIndex:i];
            numLastMatches++;
            
            // find the results for this user in this game
            for (ResultVO *result in _results) {
                if ([[result matchid] isEqualToString:[match id]] && [[result userid] isEqualToString:[player id]]) {
                    numLastPoints += [[result points] intValue];
                }
            }
            
            if (numLastMatches == 5)
                break;
        }
        
        NSNumber *lastpointsNum = [NSNumber numberWithDouble:numLastPoints];
        NSNumber *lastmatchesNum = [NSNumber numberWithDouble:numLastMatches];
        
        double lastMatchPercent = ([lastpointsNum doubleValue] / [lastmatchesNum doubleValue]) * 100;
        statistics.lastpoints = lastMatchPercent;
        
        [points addObject:statistics];
    }
    
    // loop through matches to find countergoals
    for (MatchVO *match in _matches) {
        // collect match players
        PlayerVO *player1 = [self getSinglePlayerWithId:[match userid1]];
        PlayerVO *player2 = [self getSinglePlayerWithId:[match userid2]];
        
        if (player1 != nil && player2 != nil) {
            // sort the players list based on their current rating
            NSMutableArray *rateplayers = [NSMutableArray arrayWithArray:_players];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rating" ascending:YES];
            [rateplayers sortUsingDescriptors: [NSArray arrayWithObject:sortDescriptor]];
            
            int player1rate = [self getRatePointsForUser:player1 basedOnRateList:rateplayers];
            int player2rate = [self getRatePointsForUser:player2 basedOnRateList:rateplayers];
            NSNumber *ratepoints;
            if (player1rate > player2rate)
                ratepoints = [NSNumber numberWithDouble:(player1rate - player2rate)];
            else if (player1rate < player2rate)
                ratepoints = [NSNumber numberWithDouble:(player2rate - player1rate)];
            else
                ratepoints = [NSNumber numberWithInt:rateplayers.count/2];
            
            if ([[match goals1] intValue] > [[match goals2] intValue]) {
                // player 1 won the game
                ratepoints = [NSNumber numberWithDouble:player2rate];
                NSNumber *prevPointsPlayer1 = player1.rating;
                NSNumber *prevPointsPlayer2 = player2.rating;
                
                double newratePlayer1 = [prevPointsPlayer1 doubleValue] + [ratepoints doubleValue];
                double newratePlayer2 = [prevPointsPlayer2 doubleValue] - [ratepoints doubleValue];
                
                [player1 setRating:[NSNumber numberWithDouble:newratePlayer1]];
                [player2 setRating:[NSNumber numberWithDouble:newratePlayer2]];
                
                NSLog(@"%@ (%i) vinner over %@ (%i). %@ +%f (%f)  - %@ -%f (%f)", [player1 name], player1rate, [player2 name], player2rate, [player1 name], [ratepoints doubleValue], [[player1 rating] doubleValue], [player2 name], [ratepoints doubleValue], [[player2 rating] doubleValue]);
            } else {
                // player 2 won the game
                ratepoints = [NSNumber numberWithDouble:player1rate];
                NSNumber *prevPointsPlayer1 = player1.rating;
                NSNumber *prevPointsPlayer2 = player2.rating;
                
                double newratePlayer1 = [prevPointsPlayer1 doubleValue] - [ratepoints doubleValue];
                double newratePlayer2 = [prevPointsPlayer2 doubleValue] + [ratepoints doubleValue];
                
                [player1 setRating:[NSNumber numberWithDouble:newratePlayer1]];
                [player2 setRating:[NSNumber numberWithDouble:newratePlayer2]];
                
                NSLog(@"%@ (%i) vinner over %@ (%i). %@ +%f (%f)  - %@ -%f (%f)", [player2 name], player2rate, [player1 name], player1rate, [player2 name], [ratepoints doubleValue], [[player2 rating] doubleValue], [player1 name], [ratepoints doubleValue], [[player1 rating] doubleValue]);
            }
        }
    }
    // re-enter statistics to collect new set of rating points
    for (StatisticsVO *statistic in points) {
        PlayerVO *player = [self getPlayerWithId:[statistic id]];
        [statistic setRatingpoints:[[player rating] doubleValue]];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ratingpoints" ascending:NO];
    [points sortUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    for (StatisticsVO *statistic in points) {
        NSLog(@"%@:   games: %i  - goals: %i  - points: %i  - SCORE: %f", statistic.name, statistic.totalgames, statistic.totalgoals, statistic.totalpoints, statistic.ratingpoints);
    }
    
    
    return points;
}

- (NSArray *)getTeamPointsStatistics
{
    // reset player rating score
    for (TeamVO *team in _teams) {
        [team setRating:[NSNumber numberWithDouble:500]];
    }
    
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for (TeamVO *team in _teams) {
        StatisticsVO *statistics = [[StatisticsVO alloc] init];
        [statistics setId:[team id]];
        [statistics setName:[self getTeamNameForId:[team id]]];
        [statistics setTotalgames:0];
        [statistics setTotalgoals:0];
        [statistics setTotalpoints:0];
        [statistics setRatingpoints:0];
        
        // loop through results and find all registered results for this user
        for (ResultVO *result in _results) {
            if ([[result userid] isEqualToString:[team id]]) {
                statistics.totalgames++;
                statistics.totalgoals += [[result goals] intValue];
                statistics.totalpoints += [[result points] intValue];
            }
        }
        
        // loop through matches to find countergoals
        NSMutableArray *lastMatches = [NSMutableArray new];
        for (MatchVO *match in _matches) {
            // find countergoals and to find the last 5 matches
            if ([[match userid1] isEqualToString:[team id]] || [[match userid2] isEqualToString:[team id]]) {
                // add match to last matchlist
                [lastMatches addObject:match];
                
                if ([[match userid1] isEqualToString:[team id]])
                    statistics.totalgoals -= [[match goals2] intValue];
                else
                    statistics.totalgoals -= [[match goals1] intValue];
            }
        }
        
        int numLastMatches = 0;
        int numLastPoints = 0;
        for (int i=lastMatches.count-1; i >= 0; i--) {
            MatchVO *match = [lastMatches objectAtIndex:i];
            numLastMatches++;
            
            // find the results for this user in this game
            for (ResultVO *result in _results) {
                if ([[result matchid] isEqualToString:[match id]] && [[result userid] isEqualToString:[team id]]) {
                    numLastPoints += [[result points] intValue];
                }
            }
            
            if (numLastMatches == 5)
                break;
        }
        
        NSNumber *lastpointsNum = [NSNumber numberWithDouble:numLastPoints];
        NSNumber *lastmatchesNum = [NSNumber numberWithDouble:numLastMatches];
        
        double lastMatchPercent = ([lastpointsNum doubleValue] / [lastmatchesNum doubleValue]) * 100;
        statistics.lastpoints = lastMatchPercent;
        
        [points addObject:statistics];
    }
    
    // loop through matches to find countergoals
    for (MatchVO *match in _matches) {
        // collect match players
        TeamVO *team1 = [self getTeamPlayersWithId:[match userid1]];
        TeamVO *team2 = [self getTeamPlayersWithId:[match userid2]];
        
        if (team1 != nil && team2 != nil) {
            // sort the players list based on their current rating
            NSMutableArray *rateplayers = [NSMutableArray arrayWithArray:_teams];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rating" ascending:YES];
            [rateplayers sortUsingDescriptors: [NSArray arrayWithObject:sortDescriptor]];
            
            int team1rate = [self getRatePointsForTeam:team1 basedOnRateList:rateplayers];
            int team2rate = [self getRatePointsForTeam:team2 basedOnRateList:rateplayers];
            NSNumber *ratepoints;
            if (team1rate > team2rate)
                ratepoints = [NSNumber numberWithDouble:(team1rate - team2rate)];
            else if (team1rate < team2rate)
                ratepoints = [NSNumber numberWithDouble:(team2rate - team1rate)];
            else
                ratepoints = [NSNumber numberWithInt:rateplayers.count/2];
            
            if ([[match goals1] intValue] > [[match goals2] intValue]) {
                // player 1 won the game
                ratepoints = [NSNumber numberWithDouble:team2rate];
                NSNumber *prevPointsPlayer1 = team1.rating;
                NSNumber *prevPointsPlayer2 = team2.rating;
                
                double newratePlayer1 = [prevPointsPlayer1 doubleValue] + [ratepoints doubleValue];
                double newratePlayer2 = [prevPointsPlayer2 doubleValue] - [ratepoints doubleValue];
                
                [team1 setRating:[NSNumber numberWithDouble:newratePlayer1]];
                [team2 setRating:[NSNumber numberWithDouble:newratePlayer2]];
                
                NSLog(@"%@ (%i) vinner over %@ (%i). %@ +%f (%f)  - %@ -%f (%f)", [team1 teamname], team1rate, [team2 teamname], team2rate, [team1 teamname], [ratepoints doubleValue], [[team1 rating] doubleValue], [team2 teamname], [ratepoints doubleValue], [[team2 rating] doubleValue]);
            } else {
                // player 2 won the game
                ratepoints = [NSNumber numberWithDouble:team1rate];
                NSNumber *prevPointsPlayer1 = team1.rating;
                NSNumber *prevPointsPlayer2 = team2.rating;
                
                double newratePlayer1 = [prevPointsPlayer1 doubleValue] - [ratepoints doubleValue];
                double newratePlayer2 = [prevPointsPlayer2 doubleValue] + [ratepoints doubleValue];
                
                [team1 setRating:[NSNumber numberWithDouble:newratePlayer1]];
                [team2 setRating:[NSNumber numberWithDouble:newratePlayer2]];
                
                NSLog(@"%@ (%i) vinner over %@ (%i). %@ +%f (%f)  - %@ -%f (%f)", [team2 teamname], team2rate, [team1 teamname], team1rate, [team2 teamname], [ratepoints doubleValue], [[team2 rating] doubleValue], [team1 teamname], [ratepoints doubleValue], [[team1 rating] doubleValue]);
            }
        }
    }
    // re-enter statistics to collect new set of rating points
    for (StatisticsVO *statistic in points) {
        TeamVO *team = [self getPlayerWithId:[statistic id]];
        [statistic setRatingpoints:[[team rating] doubleValue]];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ratingpoints" ascending:NO];
    [points sortUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    for (StatisticsVO *statistic in points) {
        NSLog(@"%@:   games: %i  - goals: %i  - points: %i  - SCORE: %f", statistic.name, statistic.totalgames, statistic.totalgoals, statistic.totalpoints, statistic.ratingpoints);
    }
    
    
    return points;
}


- (int)getRatePointsForUser:(PlayerVO *)player basedOnRateList:(NSArray *)ratedList
{
    int ratepoints = 1;
    for (PlayerVO *listplayer in ratedList) {
        if ([[listplayer rating] intValue] > [[player rating] intValue]) {
            return ratepoints;
        }
        ratepoints++;
    }
    return ratepoints;
}


- (int)getRatePointsForTeam:(TeamVO *)team basedOnRateList:(NSArray *)ratedList
{
    int ratepoints = 1;
    for (TeamVO *listplayer in ratedList) {
        if ([[listplayer rating] intValue] > [[team rating] intValue]) {
            return ratepoints;
        }
        ratepoints++;
    }
    return ratepoints;
}



@end
