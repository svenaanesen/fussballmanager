//
//  ConnectionManager.m
//  FussballManager
//
//  Created by Sven Aanesen on 02.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import "ConnectionManager.h"
#import "ApplicationConstants.h"
#import "AppModel.h"
#import "NotificationManager.h"

@implementation ConnectionManager



+ (ConnectionManager *)getInstance
{
    static ConnectionManager *connectionManager;
    @synchronized(self) {
        if (!connectionManager) {
            connectionManager = [[ConnectionManager alloc] init];
            
            [connectionManager setDefaults];
        }
    }
    return connectionManager;    
}

- (void)setDefaults
{
    // initialize communicator
    communicator = [[Communicator alloc] init];
    [communicator setDelegate:self];
    [communicator setAllowMultipleRequests:YES];
    activeConnections = [[NSMutableArray alloc] init];
}

#pragma mark - Communicator delegate methods

- (void)willSendRequest:(NSURLRequest *)request
{

}

- (void)didReceiveResponse:(NSURLResponse *)response
{
}


- (void)didFailWithError:(NSError *)error
{
    // remove the first connection in use
    if (activeConnections.count > 0) {
        [activeConnections removeObjectAtIndex:0];
    }
}


- (void)finishedReceivingData:(NSArray *)resultArray
{
    // remove the first connection in use
    if (activeConnections.count > 0) {
        NSString *activeConnectionType = [activeConnections objectAtIndex:0];
        if ([activeConnectionType isEqualToString:CONNECTION_URL_ADD_USER]) {
            // update the list of current users in DB
            [self getAllPlayers];
            
            // notify about the completed loading
            [[NotificationManager getInstance] notifyListeners:NotificationPlayerSavedSuccessfully object:[resultArray objectAtIndex:0] userInfo:nil];
            
        } else if ([activeConnectionType isEqualToString:CONNECTION_URL_ADD_MATCH]) {
            // update the list of current users in DB
            [[AppModel getAppModel] parseAndSetPlayers:[resultArray objectAtIndex:0]];
            
            // notify about the completed loading
            [[NotificationManager getInstance] notifyListeners:NotificationMatchSavedSuccessfully object:[resultArray objectAtIndex:0] userInfo:nil];
            
        } else if ([activeConnectionType isEqualToString:CONNECTION_URL_ADD_TEAM]) {
            // notify about the completed loading
            [[NotificationManager getInstance] notifyListeners:NotificationTeamSavedSuccessfully object:[resultArray objectAtIndex:0] userInfo:nil];
            
            // update the list of current users in DB
            //[[AppModel getAppModel] parseAndSetTeams:[resultArray objectAtIndex:0]];
            
            // update the list of current users in DB
            //[self getAllTeams];
            
            
            
        } else if ([activeConnectionType isEqualToString:CONNECTION_URL_GET_ALL_USERS]) {
            // update the list of current users in DB
            [[AppModel getAppModel] parseAndSetPlayers:[resultArray objectAtIndex:0]];
            
        } else if ([activeConnectionType isEqualToString:CONNECTION_URL_GET_ALL_TEAMS]) {
            // update the list of current users in DB
            [[AppModel getAppModel] parseAndSetTeams:[resultArray objectAtIndex:0]];
            
        } else if ([activeConnectionType isEqualToString:CONNECTION_URL_GET_MATCHES]) {
            // update the list of current users in DB
            [[AppModel getAppModel] parseAndSetMatches:[resultArray objectAtIndex:0]];
            
            // notify about the completed loading
            [[NotificationManager getInstance] notifyListeners:NotificationAllMatchesRecieved object:[resultArray objectAtIndex:0] userInfo:nil];
            
        } else if ([activeConnectionType isEqualToString:CONNECTION_URL_GET_RESULTS]) {
            // update the list of current users in DB
            [[AppModel getAppModel] parseAndSetResults:[resultArray objectAtIndex:0]];
            
            // notify about the completed loading
            [[NotificationManager getInstance] notifyListeners:NotificationAllResultsRecieved object:[resultArray objectAtIndex:0] userInfo:nil];
            
        }
        [activeConnections removeObjectAtIndex:0];
    }
}



#pragma mark - adding info to database

- (void)addPlayerWithName:(NSString *)playername andDepartmentName:(NSString *)departmentName
{
    NSLog(@"addPlayerWithName...");
    NSMutableString *post = [[NSMutableString alloc] initWithString:@""];
    NSString *userid = [NSString stringWithFormat:@"%i", (int)[NSDate timeIntervalSinceReferenceDate]];
    [post appendFormat:@"id=%@", [userid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [post appendFormat:@"&name=%@", [playername stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [post appendFormat:@"&imagereference=%@", @""];
    [post appendFormat:@"&department=%@", [departmentName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [activeConnections addObject:CONNECTION_URL_ADD_USER];    
    [communicator sendRequest:post toURL:CONNECTION_URL_ADD_USER];
}

- (NSString *)addMatchWithPlayerOneId:(NSString *)player1id andPlayerTwoId:(NSString *)player2id withPlayerOnePoints:(int)player1points andPlayerTwoPoints:(int)player2points
{
    NSLog(@"addMatch...");
    NSMutableString *post = [[NSMutableString alloc] initWithString:@""];
    NSString *matchid = [NSString stringWithFormat:@"%i", (int)[NSDate timeIntervalSinceReferenceDate]];
    [post appendFormat:@"matchid=%@", matchid];
    [post appendFormat:@"&userid_1=%@", player1id];
    [post appendFormat:@"&userid_2=%@", player2id];
    [post appendFormat:@"&date=%@", [[self getCurrentDateAsString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [post appendFormat:@"&goals_user1=%i", player1points];
    [post appendFormat:@"&goals_user2=%i", player2points];    
    
    [activeConnections addObject:CONNECTION_URL_ADD_MATCH];
    [communicator sendRequest:post toURL:CONNECTION_URL_ADD_MATCH];
    
    return matchid;
}

- (NSString *)addTeamWithName:(NSString *)teamName withPlayerOneId:(NSString *)player1id andPlayerTwoId:(NSString *)player2id
{    
    NSMutableString *post = [[NSMutableString alloc] initWithString:@""];
    [post appendFormat:@"teamid=%@", [teamName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [post appendFormat:@"&userid_1=%@", player1id];
    [post appendFormat:@"&userid_2=%@", player2id];
    [post appendFormat:@"&teamname=%@", [teamName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"AddTeam: %@", teamName);
    
    [activeConnections addObject:CONNECTION_URL_ADD_TEAM];
    [communicator sendRequest:post toURL:CONNECTION_URL_ADD_TEAM];
    
    return teamName;
}

- (void)addResultsForUserId:(NSString *)userId withPoints:(int)points andGoals:(int)goals playingInMatchWithId:(NSString *)matchId
{    
    NSLog(@"addResultsForUserId...");
    NSMutableString *post = [[NSMutableString alloc] initWithString:@""];
    [post appendFormat:@"userid=%@", [userId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [post appendFormat:@"&points=%i", points];
    [post appendFormat:@"&goals=%i", goals];
    [post appendFormat:@"&matchid=%@", matchId];
    
    [activeConnections addObject:CONNECTION_URL_ADD_RESULT];
    [communicator sendRequest:post toURL:CONNECTION_URL_ADD_RESULT];
}

- (NSString *)getCurrentDateAsString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *stringFromDate = [dateFormatter stringFromDate:[NSDate date]];
    return stringFromDate;
}

#pragma mark - collecting data fra database

- (void)getAllPlayers
{
    NSMutableString *post = [[NSMutableString alloc] initWithString:@""];
    [activeConnections addObject:CONNECTION_URL_GET_ALL_USERS];
    [communicator sendRequest:post toURL:CONNECTION_URL_GET_ALL_USERS];
}

- (void)getAllTeams
{
    NSMutableString *post = [[NSMutableString alloc] initWithString:@""];
    [activeConnections addObject:CONNECTION_URL_GET_ALL_TEAMS];
    [communicator sendRequest:post toURL:CONNECTION_URL_GET_ALL_TEAMS];
}

- (void)getAllMatches
{
    NSMutableString *post = [[NSMutableString alloc] initWithString:@""];
    [activeConnections addObject:CONNECTION_URL_GET_MATCHES];
    [communicator sendRequest:post toURL:CONNECTION_URL_GET_MATCHES];
}

- (void)getAllResults
{
    
    NSMutableString *post = [[NSMutableString alloc] initWithString:@""];
    [activeConnections addObject:CONNECTION_URL_GET_RESULTS];
    [communicator sendRequest:post toURL:CONNECTION_URL_GET_RESULTS];
}


@end
