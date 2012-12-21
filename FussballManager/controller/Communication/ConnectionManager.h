//
//  ConnectionManager.h
//  FussballManager
//
//  Created by Sven Aanesen on 02.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Communicator.h"

@interface ConnectionManager : NSObject <CommunicatorDelegate> {


    Communicator *communicator;
    
    NSMutableArray *activeConnections;
}


+ (ConnectionManager *)getInstance;


// adding info to database

- (void)addPlayerWithName:(NSString *)playername andDepartmentName:(NSString *)departmentName;

- (NSString *)addMatchWithPlayerOneId:(NSString *)player1id andPlayerTwoId:(NSString *)player2id withPlayerOnePoints:(int)player1points andPlayerTwoPoints:(int)player2points;

- (NSString *)addTeamWithName:(NSString *)teamName withPlayerOneId:(NSString *)player1id andPlayerTwoId:(NSString *)player2id;

- (void)addResultsForUserId:(NSString *)userId withPoints:(int)points andGoals:(int)goals playingInMatchWithId:(NSString *)matchId;



// collecting data fra database

- (void)getAllPlayers;

- (void)getAllTeams;

- (void)getAllMatches;

- (void)getAllResults;



@end
