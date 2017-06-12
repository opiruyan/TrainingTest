//
//  HTLoginScreenViewController.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/3/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTLoginScreenViewController.h"
#import <SafariServices/SafariServices.h>
#import "HTAuthenticationManager.h"
#import "HTSettings.h"
#import <Lockbox/Lockbox.h>

#define clientId @"1688719b-f2a6-47c4-b727-bee9aeee90b1"

@interface HTLoginScreenViewController () <SFSafariViewControllerDelegate>

@end

@implementation HTLoginScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedAuthentication) name:kHandlingURLNotification object:nil];
    self.isLogged = NO;
    //[Lockbox archiveObject:nil forKey:@"token"];
}

- (void)viewDidAppear:(BOOL)animated
{
    HTAuthenticationManager *manager = [HTAuthenticationManager sharedManager];
    if (![manager authorized])
    {
        if (!self.isLogged)
        {
            [self oauth2];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"loginFinishedSegue" sender:self];
    }
}

#pragma mark - Authorization


- (void)oauth2
{
    NSString *host = [[HTSettings sharedSettings] host];
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
    NSString *urlString = [NSString stringWithFormat:@"%@/oauth2/authorize/?client_id=%@&redirect_uri=%@://&response_type=code", host, clientId, urlSchemes.firstObject];
    SFSafariViewController *authViewContoller = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:urlString]];
    authViewContoller.preferredBarTintColor = [UIColor grayColor];
    [self presentViewController:authViewContoller animated:YES completion:nil];
}

- (void)finishedAuthentication
{
    self.isLogged = YES;
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"loginFinishedSegue" sender:self];
    }];
}

@end

