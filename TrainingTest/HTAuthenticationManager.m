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

#define clientId @"1688719b-f2a6-47c4-b727-bee9aeee90b1"
#define clientSecret @"cdfd0af6-38a0-4277-8d80-400055ae766e"

@interface HTAuthenticationManager ()

@property (nonatomic, strong) HTAuthenticationToken *authToken;

@end

@implementation HTAuthenticationManager

+ (id)sharedManager
{
    static HTAuthenticationManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAuthenticateNotification:) name:kHandlingURLNotification object:nil];
    }
    return self;
}

- (HTAuthenticationToken *)authToken
{
#warning move refreshing out of here
    if (_authToken.expired)
    {
        [self refreshToken];
    }
    return _authToken;
}

- (void)didAuthenticateNotification:(NSNotification *)notification
{
    // get authorization code
    NSURL *url = [notification.userInfo objectForKey:@"CallbackURL"];
    NSRange range = [url.absoluteString rangeOfString:@"="];
    NSString *retrievedCode = [url.absoluteString substringFromIndex:range.location+range.length];
    // callback uri
    //NSArray *urlSchemes = [self appUrlSchemes];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:@"authorization_code" forKey:@"grant_type"];
    [dict setValue:retrievedCode forKey:@"code"];
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
