//
//  UIViewController+Processing.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 08/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "UIViewController+Processing.h"
#import "HTSpinnerViewController.h"

@implementation UIViewController (Processing)

-(void)showComplete
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HTSpinnerViewController *spinnerViewController = [storyboard instantiateViewControllerWithIdentifier:SpinnerViewControllerIdentifier];
#warning looks ugly
    spinnerViewController.view.backgroundColor = [UIColor colorWithRed:143/255.0 green:210/255.0 blue:0 alpha:1];
    spinnerViewController.spinnerImageView.image = [UIImage imageNamed:@"confirmationIcon"];
    spinnerViewController.messgaeLabel.text = @"Transaction Confirmed";
    [self presentViewController:spinnerViewController animated:YES completion:^{
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
            [spinnerViewController finish];
        });
    }];
}

@end
