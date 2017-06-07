//
//  HTSpinnerViewController.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 05/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTSpinnerViewController : UIViewController

@property (weak, nonatomic, readonly) IBOutlet UIImageView *spinnerImageView;

- (void)rotate;

@end
