//
//  NSDuck.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/2/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "NSDuck.h"

@implementation NSDuck

- (void)display
{
    // empty
}

- (void)fly
{
    [_flyDelegate performFly];
}

- (void)quack
{
    [_quackDelegate performQuack];
}

- (void)setFlyDelegate:(id<FlyBehavior>)flyDelegate
{
    _flyDelegate = flyDelegate;
}

- (void)setQuackDelegate:(id<QuackBehavior>)quackDelegate
{
    _quackDelegate = quackDelegate;
    
}


@end
