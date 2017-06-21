//
//  HTAuthenticationManager.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 03/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTAuthenticationManager.h"
#import "HTWebProvider.h"
#import "HTAuthenticationToken.h"
#import "HTSettings.h"

NSString *const kHandlingURLNotification = @"applicationLaunchedWithURLNotification";

NSString *const clientId = @"1688719b-f2a6-47c4-b727-bee9aeee90b1";
static NSString *const clientSecret = @"cdfd0af6-38a0-4277-8d80-400055ae766e";

@interface HTAuthenticationManager ()

@property (nonatomic, strong) HTAuthenticationToken *authToken;

@end

@implementation HTAuthenticationManager

- (void)setAuthToken:(HTAuthenticationToken *)authToken
{
    _authToken = authToken;
    if (_authToken.expired)
    {
        [self refreshToken];
    }
}

- (void)exchangeCodeForToken:(NSString *)code
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:@"authorization_code" forKey:@"grant_type"];
    [dict setValue:code forKey:@"code"];
    [dict setValue:clientSecret forKey:@"client_secret"];
    [dict setValue:clientId forKey:@"client_id"];
    [dict setValue:@"harborpay://" forKey:@"redirect_uri"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    HTWebProvider *webProvider = [HTWebProvider sharedProvider];
    [webProvider postRequestWithBody:data completionHandler:^(NSData *data) {
        NSError *parseError = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (!parseError)
        {
            if ([result objectForKey:@"error"])
            {
                NSLog(@"%@", [result objectForKey:@"error_description"]);
            }
            else
            {
                [[HTSettings sharedSettings] saveAuthenticationToken:result];
            }
        }
    }];
}

- (BOOL)authorized
{
    self.authToken = [HTAuthenticationToken tokenFromKeychain];
    [[HTSettings sharedSettings] setToken:self.authToken];
    return self.authToken == nil ? NO : YES;
}

// should be moved to token class 
- (void)refreshToken
{
    HTWebProvider *webProvider = [HTWebProvider sharedProvider];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:@"refresh_token" forKey:@"grant_type"];
#warning should get with a setter
    [dict setValue:_authToken.refreshToken forKey:@"refresh_token"];
    [dict setValue:clientSecret forKey:@"client_secret"];
    [dict setValue:clientId forKey:@"client_id"];
    [webProvider refreshToken:dict completionHandler:^(NSData *data) {
        NSError *parseError = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (!parseError)
        {
            [[HTSettings sharedSettings] saveAuthenticationToken:result];
        }
    }];
}

#pragma mark - Utils

- (NSArray *)appUrlSchemes
{
    // retrieve app url
    NSArray *urlTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    NSArray *urlSchemes = [NSArray new];
    for (NSDictionary *dict in urlTypes)
    {
        if ([dict objectForKey:@"CFBundleURLSchemes"] )
        {
            urlSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
        }
    }
    return urlSchemes;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
