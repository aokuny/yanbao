//
//  NSDictionary+Uitls.m
//  CheleNetClinet
//
//  Created by aokuny on 14-10-17.
//  Copyright (c) 2014年 aokuny. All rights reserved.//

#import "NSDictionary+Uitls.h"

NSString * const kEmptyString = @"";

@implementation NSDictionary (Utils)
-(CGFloat )floatForKey:(id)key {
    NSNumber *result = [self objectForKey:key];
    if ([result isKindOfClass:[NSNumber class]]) {
        return  [result doubleValue];
    }
    return 0.0f;
}

//return an empty string if the value is null or not a string.
- (NSString *)stringForKey:(id)key
{
    NSString *result = [self objectForKey:key];
    if([result isKindOfClass:[NSString class]])
    {
        return result;
    }
    else {
        return kEmptyString;
    }
}

-(BOOL) boolForKey:(id)key {
    id result = [self objectForKey:key];
    if ([result isKindOfClass:[NSNumber class]]) {
        return [result boolValue];
    }
    else {
        return false;
    }
}

//return nil if the object is null or not a NSDictionary.
- (NSDictionary *)dictionaryForKey:(id)key
{
    NSDictionary *result = [self objectForKey:key];
    if([result isKindOfClass:[NSDictionary class]])
    {
        return result;
    }
    else {
        return nil;
    }
}

//return nil if the object is null or not a NSArray.
- (NSArray *)arrayForKey:(id)key
{
    NSArray *result = [self objectForKey:key];
    if([result isKindOfClass:[NSArray class]])
    {
        return result;
    }
    else {
        return nil;
    }
}
@end
