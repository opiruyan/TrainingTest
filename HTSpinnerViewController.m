//
//  HTSpinnerViewController.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 05/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTSpinnerViewController.h"

@interface HTSpinnerViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *spinnerImageView;

@end

@implementation HTSpinnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)rotate
{
    [self rotateLayerInfinite:_spinnerImageView	.layer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rotateLayerInfinite:(CALayer *)layer
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    rotation.duration = 1.1f;
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [layer removeAllAnimations];
    [layer addAnimation:rotation forKey:@"Spin"];
}

@end
