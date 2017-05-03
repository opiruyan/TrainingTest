//
//  HTLoginScreenViewController.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/3/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTLoginScreenViewController.h"
#import "NSString+UUID.h"
#import "NSString+SHA256.h"
#import <SafariServices/SafariServices.h>

#define clientId @"1688719b-f2a6-47c4-b727-bee9aeee90b1"

@interface HTLoginScreenViewController () <SFSafariViewControllerDelegate, AppURLOpenDelegate>

@end

@implementation HTLoginScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Authorization
- (IBAction)login:(UIButton *)sender
{
    //[self getAuthorization];
    [self generateKey];
    
}

- (void)getAuthorization
{
    NSString *host = @"https://lighthouse-api-staging.harbortouch.com";
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
    // form an url
    NSString *urlString = [NSString stringWithFormat:@"%@/oauth2/authorize/?client_id=%@&redirect_uri=%@://&response_type=code&permissions=1", host, clientId, urlSchemes.firstObject];
    SFSafariViewController *authViewContoller = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:urlString]];
    [self presentViewController:authViewContoller animated:YES completion:nil];
}

- (void)generateKey
{
    NSDictionary *requestJSON  = [NSDictionary dictionaryWithObject:@{
                                                                      @"mid" : @"String",
                                                                      @"userID": @"String",
                                                                      @"password": @"String",
//                                                                      @"developerID": @"test_developerID"
                                                                      }
                                                             forKey:@"GenerateKey"];
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestJSON options:0 error:&error];
    NSString *gatewayUrl = @"https://gateway.transit-pass.com/servlets/TransNox_API_Server";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:gatewayUrl]];
    [request setHTTPBody:requestData];
    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *registration = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@", response);
    }];
    [registration resume];
}

@end

