//
//  HTSettings.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 31/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTSettings.h"
#import "HTWebProvider.h"

@interface HTSettings ()

@end

@implementation HTSettings

@synthesize tsysDeviceId = _tsysDeviceId;
@synthesize tsysTransactionKey = _tsysTransactionKey;
@synthesize tsysServerUrl = _tsysServerUrl;

+ (id)sharedSettings
{
    static HTSettings *settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settings = [[self alloc] init];
    });
    return settings;
}

#pragma mark - Config

- (NSString *)host
{
    return @"https://lighthouse-api-staging.harbortouch.com";
}

#pragma mark - Authentication

- (void)saveAuthenticationToken:(NSDictionary *)tokenDictionary
{
    self.token = [HTAuthenticationToken tokenWithDicitonary:tokenDictionary];
    [self.token save];
    [self getTSYSProcessingCredintials];
}

- (void)getTSYSProcessingCredintials
{
    HTWebProvider *webProvider = [HTWebProvider sharedProvider];
    [webProvider GETRequestToEndpoint:@"/api/v1/echo-pro/settings?type=processing&location=77" body:nil withToken:self.token.accessToken completionHandler:^(NSData *data) {
        if (data)
        {
            NSError *parseError = nil;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSMutableDictionary *values = [NSMutableDictionary new];
            for (NSDictionary *settings in [result objectForKey:@"settings"])
            {
                [values setValue:[settings objectForKey:@"value"] forKey:[settings objectForKey:@"name"]];
            }
            self.tsysDeviceId = [values objectForKey:@"device_id"];
            self.tsysTransactionKey = [values objectForKey:@"transaction_key"];
            self.tsysMerchantId = [values objectForKey:@"merchant_id"];
            self.tsysServerUrl = [values objectForKey:@"server_url"];
        }
    }];
}

- (void)setTsysDeviceId:(NSString *)tsysDeviceId
{
    _tsysDeviceId = tsysDeviceId;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_tsysDeviceId forKey:@"deviceId"];
    [userDefaults synchronize];
}

- (NSString *)tsysDeviceId
{
    if (_tsysDeviceId == nil)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _tsysDeviceId = [userDefaults objectForKey:@"deviceId"];
    }
    return _tsysDeviceId;
}

- (void)setTsysTransactionKey:(NSString *)tsysTransactionKey
{
    _tsysTransactionKey = tsysTransactionKey;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_tsysTransactionKey forKey:@"transactionKey"];
    [userDefaults synchronize];
}

- (NSString *)tsysTransactionKey
{
    if (_tsysTransactionKey == nil)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _tsysTransactionKey = [userDefaults objectForKey:@"transactionKey"];
    }
    return _tsysTransactionKey;
}

- (void)setTsysServerUrl:(NSString *)tsysServerUrl
{
    _tsysServerUrl = tsysServerUrl;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_tsysDeviceId forKey:@"server_url"];
    [userDefaults synchronize];
}

- (NSString *)tsysServerUrl
{
    if (_tsysServerUrl == nil)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _tsysServerUrl = [userDefaults objectForKey:@"server_url"];
    }
    return _tsysServerUrl;
}


- (void)getLocations
{
    HTWebProvider *webProvider = [HTWebProvider sharedProvider];
    [webProvider GETRequestToEndpoint:@"/api/v1/locations" body:nil withToken:self.token.accessToken completionHandler:^(NSData *data) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", result);
    }];
}

@end
