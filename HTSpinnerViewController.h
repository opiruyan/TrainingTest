//
//  HTSpinnerViewController.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 05/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *SpinnerViewControllerIdentifier = @"HTSpinnerViewController";

@interface HTSpinnerViewController : UIViewController

@property (weak, nonatomic, readonly) IBOutlet UIImageView *spinnerImageView;
@property (weak, nonatomic, readonly) IBOutlet UILabel *messgaeLabel;

- (void)rotate;
- (void)finish;

@end
