//
//  HTStartNavigationController.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 09/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTStartNavigationController.h"
#import "HTAuthenticationManager.h"
#import <SafariServices/SafariServices.h>
#import "HTSettings.h"

#define clientId @"1688719b-f2a6-47c4-b727-bee9aeee90b1"

@interface HTStartNavigationController ()

@end

@implementation HTStartNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedAuthentication) name:kHandlingURLNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishedAuthentication
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"loginFinishedSegue" sender:self];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
