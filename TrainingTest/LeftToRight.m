//
//  LeftToRight.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/1/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "LeftToRight.h"

@implementation LeftToRight

- (void)perform
{
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    
    [sourceViewController.view insertSubview:destinationViewController.view aboveSubview:sourceViewController.view];
    destinationViewController.view.transform = CGAffineTransformMakeTranslation(sourceViewController.view.frame.size.width, 0);
    
    [UIView animateWithDuration:0.1
                          delay:0.5
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         destinationViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
                     }
                     completion:nil];
}

@end
