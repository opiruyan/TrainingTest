//
//  HTSafariViewContoller.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 26/04/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTSafariViewContoller.h"
#import <SafariServices/SafariServices.h>

@interface HTSafariViewContoller () <SFSafariViewControllerDelegate>
@end

@implementation HTSafariViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    SFSafariViewController *authViewController = [[SFSafariViewController alloc] initWithURL:self.urlToOpen];
    authViewController.delegate = self;
    [self presentViewController:authViewController animated:YES completion:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
