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

@interface HTLoginScreenViewController () <SFSafariViewControllerDelegate>

// most likely useless. like entity
@property (strong, nonatomic) HTAuthenticationManager *authenticationManager;

@end

@implementation HTLoginScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedAuthentication:) name:kHandlingURLNotification object:nil];
    self.isLogged = NO;
}

- (HTAuthenticationManager *)authenticationManager
{
    if (!_authenticationManager)
    {
        _authenticationManager = [HTAuthenticationManager new];
    }
    return _authenticationManager;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![self.authenticationManager authorized])
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

- (void)finishedAuthentication:(NSNotification *)notification
{
    self.isLogged = YES;
    // get authorization code
    NSURL *url = [notification.userInfo objectForKey:@"CallbackURL"];
    NSRange range = [url.absoluteString rangeOfString:@"="];
    NSString *retrievedCode = [url.absoluteString substringFromIndex:range.location+range.length];
    [self.authenticationManager exchangeCodeForToken:retrievedCode];
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"loginFinishedSegue" sender:self];
    }];
}

@end

