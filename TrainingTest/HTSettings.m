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

@property (nonatomic, strong) NSString *tsysDeviceId;
@property (nonatomic, strong) NSString *tsysTransactionKey;
@property (nonatomic, strong) NSString *tsysMerchantId;
@property (nonatomic, strong) NSString *tsysServerUrl;

@end

@implementation HTSettings

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

- (void)getLocations
{
    HTWebProvider *webProvider = [HTWebProvider sharedProvider];
    [webProvider GETRequestToEndpoint:@"/api/v1/locations" body:nil withToken:self.token.accessToken completionHandler:^(NSData *data) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", result);
    }];
}

@end
