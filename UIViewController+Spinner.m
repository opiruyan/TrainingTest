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

@end
