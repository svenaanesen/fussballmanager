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


@end
