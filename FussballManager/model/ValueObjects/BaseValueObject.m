//
//  BaseValueObject.m
//  Eniro
//
//  Created by Sven Aanesen on 30.08.11.
//  Copyright 2011 Eniro. All rights reserved.
//

#import "BaseValueObject.h"

@implementation BaseValueObject

- (id)initWithInfo:(NSDictionary *)info
{ 
	if((self = [super init])) {
        [self setDefaultValues];
        [self parseInfo:info];
	}
	return self;
}

- (void)setDefaultValues
{
   
}

- (void)parseInfo:(NSDictionary *)info
{
}

- (id)getValueInObject:(NSDictionary *)dict fromKey:(NSString *)key
{
    @try {
        id value = [dict objectForKey:key];
        return (value && ![value isKindOfClass:[NSNull class]]) ? value : nil;
    }
    @catch (NSException *exception) {
        // value collection failed
        return nil;
    }   
}

- (NSString *)getId
{
    return nil;
}

- (CLLocation *)getLocation
{
    return nil;
}


- (NSDictionary *)objectAsDictionary
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    
    NSLog(@"objectAsDictionary: %@", props);
    return props;
}

@end
