//
//  HTSignatureViewController.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/11/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTSignatureViewController.h"
#import "HTSignatureView.h"
#import "UIViewController+Processing.h"

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
    self.signatureView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)cancelPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cleanPressed:(UIButton *)sender
{
    [self.signatureView clearPath];
    [self.signatureView setNeedsDisplay];
    self.placeholderLabel.hidden = NO;
}

- (IBAction)confirmPressed:(UIButton *)sender
{
    [self showComplete];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    HTSignatureViewController *signatureViewController = [storyboard instantiateViewControllerWithIdentifier:@"HTCloseTicketViewController"];
//    [self presentViewController:signatureViewController animated:YES completion:nil];
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
