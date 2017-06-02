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

+ (HTAuthenticationToken *)tokenFromKeychain
{
    NSDictionary *tokenDictionary = [Lockbox unarchiveObjectForKey:@"token"];
    HTAuthenticationToken *token = [[HTAuthenticationToken alloc] initWithDictionary:tokenDictionary];
    return token;
}

- (void)serializeFromDictionary:(NSDictionary *)dict
{
    _accessToken = [dict objectForKey:@"access_token"];
    _refreshToken = [dict objectForKey:@"refresh_token"];
    _tokenType = [dict objectForKey:@"token_type"];
}

- (NSDictionary *)deserialize
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setValue:self.accessToken forKey:@"access_token"];
    [dictionary setValue:self.refreshToken forKey:@"refresh_token"];
    [dictionary setValue:self.accessToken forKey:@"token_type"];
    return dictionary;
}

- (BOOL)expired
{
    NSDate *now = [NSDate date];
    NSDate *tokenExpirationDate = [self expDate];
    return [tokenExpirationDate earlierDate:now] == tokenExpirationDate ? YES : NO;
}

- (void)save
{
    [Lockbox archiveObject:[self deserialize] forKey:@"token"];
}

- (NSDate *)expDate
{
    NSDate *expDate = nil;
    NSError *decodingError = nil;
    NSDictionary *jwtPayload = [self decodeJwt:self.accessToken error:&decodingError];
    if (jwtPayload)
    {
        NSNumber *timeInterval  = [jwtPayload objectForKey:@"exp"];
        expDate = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval.doubleValue];
    }
    return expDate;
}

- (NSDictionary *)decodeJwt:(NSString *)jwt error:(NSError **)error
{
    *error = [NSError errorWithDomain:@"com.harbortouch.ahrborpay" code:-1000 userInfo:@{@"info" : @"Not a JWT"}];
    NSArray *segments = [jwt componentsSeparatedByString:@"."];
    if([segments count] != 3)
    {
        *error = [NSError errorWithDomain:@"com.harbortouch.ahrborpay" code:-1000 userInfo:@{@"info" : @"Not a JWT"}];
        return nil;
    }
    
    //  segments are base64
    NSString *payloadSeg = segments[1]; // payload is where info we need is stored
    
    // Decode and parse payload JSON
    NSError *serializationError = nil;
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:[self base64DecodeWithString:payloadSeg] options:NSJSONReadingMutableLeaves error:&serializationError];
    if(payload == nil)
    {
        *error = [NSError errorWithDomain:@"com.harbortouch.ahrborpay" code:-1001 userInfo:@{@"info" :@"Cannot deserialize payload"}];
        return nil;
    }
    return payload;
}

#pragma mark - Utils

- (NSData *)base64DecodeWithString:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    string = [string stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    int size = [string length] % 4;
    NSMutableString *segment = [[NSMutableString alloc] initWithString:string];
    for (int i = 0; i < size; i++) {
        [segment appendString:@"="];
    }
    
    return [[NSData alloc] initWithBase64EncodedString:segment options:0];
}

@end