//
//  UIViewController+Back.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 09/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "UIViewController+Back.h"

@implementation UIViewController (Back)

- (void)setCustomBackWithTarget:(id)target
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    backButton.contentMode = UIViewContentModeLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    UIImage *backImage = [UIImage imageNamed:@"backBtn"];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:target action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    // update size
    CGSize size = [backButton intrinsicContentSize];
    backButton.frame = CGRectMake(0, 0, size.width, size.height);
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)backPressed:(id)sender
{
    // default implementation
    [self.navigationController popViewControllerAnimated:YES];
}

@end
