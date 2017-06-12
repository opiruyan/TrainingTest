//
//  UIViewController+Spinner.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 08/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "UIViewController+Spinner.h"
#import "HTSpinnerViewController.h"

@implementation UIViewController (Spinner)

- (void)showSpinner
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HTSpinnerViewController *spinnerViewController = [storyboard instantiateViewControllerWithIdentifier:SpinnerViewControllerIdentifier];
    spinnerViewController.definesPresentationContext = YES;
    spinnerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    spinnerViewController.spinnerImageView.image = [UIImage imageNamed:@"spinner"];
    [self presentViewController:spinnerViewController animated:YES completion:^{
        [spinnerViewController rotate];
    }];
}

- (void)hideSpinner
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideSpinnerToContinue:(BOOL)success
{
    HTSpinnerViewController *spinner = (HTSpinnerViewController *)self.presentedViewController;
    dispatch_async(dispatch_get_main_queue(), ^{
        [spinner stopRotating];
        if (success)
        {
            spinner.view.backgroundColor = [UIColor colorWithRed:143/255.0 green:210/255.0 blue:0 alpha:1];
            spinner.spinnerImageView.image = [UIImage imageNamed:@"confirmationIcon"];
            spinner.messgaeLabel.text = @"Transaction Confirmed";
        }
        else
        {
            spinner.view.backgroundColor = [UIColor colorWithRed:196/255.0 green:2/255.0 blue:0 alpha:1];
            spinner.spinnerImageView.image = [UIImage imageNamed:@"declinedIcon"];
            spinner.messgaeLabel.text = @"Transaction Declined";
        }
    });
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        //code to be executed on the main queue after delay
        if (success)
        {
            [spinner finish];
        }
        else
        {
            [spinner dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

@end
