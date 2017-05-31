//
//  HTAuthenticationToken.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 26/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTAuthenticationToken.h"
#import <Lockbox/Lockbox.h>

@implementation HTAuthenticationToken

+ (instancetype)tokenWithDicitonary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        [self serializeFromDictionary:dictionary];
    }
    return self;
}

- (void)serializeFromDictionary:(NSDictionary *)dict
{
    _accessToken = [dict objectForKey:@"access_token"];
    _refreshToken = [dict objectForKey:@"refresh_token"];
    _tokenType = [dict objectForKey:@"token_type"];
}

+ (HTAuthenticationToken *)tokenFromKeychain
{
    NSDictionary *tokenDictionary = [Lockbox unarchiveObjectForKey:@"token"];
    HTAuthenticationToken *token = [[HTAuthenticationToken alloc] initWithDictionary:tokenDictionary];
    return token;
}

- (NSDictionary *)deserialize
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setValue:self.accessToken forKey:@"access_token"];
    [dictionary setValue:self.refreshToken forKey:@"refresh_token"];
    [dictionary setValue:self.accessToken forKey:@"token_type"];
    return dictionary;
}

- (void)save
{
    [Lockbox archiveObject:[self deserialize] forKey:@"token"];
}

@end
