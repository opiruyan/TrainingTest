//
//  NSModelDuck.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/2/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "NSModelDuck.h"
#import "FlyNoWay.h"
#import "Quack.h"

@implementation NSModelDuck

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.flyDelegate = [FlyNoWay new];
        self.quackDelegate = [Quack new];
    }
    return self;
}

- (void)display
{
    NSLog(@"im a model duck");
}

@end
