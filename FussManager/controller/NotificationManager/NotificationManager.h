//
//  NotificationManager.h
//  Eniro
//
//  This class works as a simple notification class which really only uses the 
//  default NotificationCenter to publish notification between Classes.
//  The purpose is to control the notification types that is beeing sent.
//
//  Created by Sven Aanesen on 24.08.11.
//  Copyright 2011 Eniro. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NotificationMatchSavedSuccessfully          @"NotificationMatchSavedSuccessfully"
#define NotificationMatchSavedWithFailure           @"NotificationMatchSavedWithFailure"
#define NotificationAllMatchesRecieved              @"NotificationAllMatchesRecieved"

#define NotificationTeamSavedSuccessfully           @"NotificationTeamSavedSuccessfully"
#define NotificationTeamSavedWithFailure            @"NotificationTeamSavedWithFailure"

#define NotificationPlayerSavedSuccessfully         @"NotificationPlayerSavedSuccessfully"
#define NotificationPlayerSavedWithFailure          @"NotificationPlayerSavedWithFailure"

#define NotificationResultsSavedSuccessfully        @"NotificationResultsSavedSuccessfully"
#define NotificationResultsSavedWithFailure         @"NotificationResultsSavedWithFailure"
#define NotificationAllResultsRecieved              @"NotificationAllResultsRecieved"



@interface NotificationManager : NSObject {}


+ (NotificationManager *)getInstance;


// adds a listener (to be notified) that listens for notifications
- (void)addListener:(id)listener selector:(SEL)theSelector listenerType:(NSString *)typeName;

// removes a registered listener
- (void)removeListener:(id)listener listenerType:(NSString *)typeName;

// sends out a notification to anyone listening
- (void)notifyListeners:(NSString *)listenerType object:(id)notificationSender userInfo:(NSDictionary *)userInfo;


@end
