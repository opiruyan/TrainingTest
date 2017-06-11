//
//  UIView+Animation.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 07/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)animateSwipe
{
    UIScreen *window = [UIScreen mainScreen];
    [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [UIView animateWithDuration:2.5 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromLeft
                         animations:^{
                             self.frame = CGRectMake(window.bounds.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             //return the card back
                             self.frame = CGRectMake(-self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
                         }];
    }];
}

- (void)animateZoomIn
{
    self.translatesAutoresizingMaskIntoConstraints = YES;
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromLeft
                     animations:^{
                         float zoomKoef = 1.3;
                         CGRect frame = self.frame;
                         frame.size.height = self.frame.size.height*zoomKoef;
                         frame.size.width = self.frame.size.width*zoomKoef;
                         frame.origin.x = self.frame.origin.x + (1 - zoomKoef)/2 * self.frame.size.width;
                         frame.origin.y = self.frame.origin.y + (1 - zoomKoef) * self.frame.size.height;
                         self.frame = frame;
                     }
                     completion:nil];
}

@end
