//
//  NotificationManager.m
//  Eniro
//
//  Created by Sven Aanesen on 24.08.11.
//  Copyright 2011 Eniro. All rights reserved.
//

#import "NotificationManager.h"


@implementation NotificationManager


+ (NotificationManager *)getInstance
{
    static NotificationManager *notificationManager;
    @synchronized(self) {
        if (!notificationManager) {
            notificationManager = [[NotificationManager alloc] init];
        }
    }
    return notificationManager;
}

- (void)addListener:(id)listener selector:(SEL)theSelector listenerType:(NSString *)typeName
{
    [[NSNotificationCenter defaultCenter] addObserver:listener selector:theSelector name:typeName object:nil];
}

- (void)removeListener:(id)listener listenerType:(NSString *)typeName
{
    [[NSNotificationCenter defaultCenter] removeObserver:listener name:typeName object:nil];
}

- (void)notifyListeners:(NSString *)listenerType object:(id)notificationSender userInfo:(NSDictionary *)userInfo
{
    if (userInfo) {
        [[NSNotificationCenter defaultCenter] postNotificationName:listenerType object:notificationSender userInfo:userInfo];
        
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:listenerType object:notificationSender];
    }
    
    
}


@end
