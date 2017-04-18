//
//  HTSignatureViewController.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/11/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTSignatureViewController.h"
#import "HTSignatureView.h"

@interface HTSignatureViewController () <HTSignatureViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet HTSignatureView *signatureView;

@end

@implementation HTSignatureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
    // Do any additional setup after loading the view.
    self.signatureView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - HTSignatureViewDelegate

- (void)signatureViewDidStartEditing:(UIView *)view
{
    self.placeholderLabel.hidden = YES;
}

@end
