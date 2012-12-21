//
//  BaseValueObject.h
//  Eniro
//
//  Created by Sven Aanesen on 30.08.11.
//  Copyright 2011 Eniro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <objc/runtime.h>

@interface BaseValueObject : NSObject {
}

- initWithInfo:(NSDictionary *)info;
- (void)setDefaultValues;
- (void)parseInfo:(NSDictionary *)info;
- (id)getValueInObject:(NSDictionary *)dict fromKey:(NSString *)key;

- (NSString *)getId;

- (CLLocation *)getLocation;

- (NSDictionary *)objectAsDictionary;

- (NSString*) getDescriptionForSharing;

@end

