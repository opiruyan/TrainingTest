//
//  NSMallardDuck.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/2/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "NSMallardDuck.h"
#import "FlyWithWings.h"
#import "Quack.h"

@implementation NSMallardDuck

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.flyDelegate = [FlyWithWings new];
        self.quackDelegate = [Quack new];
    }
    return self;
}

- (void)display
{
    NSLog(@"I'm a real Mallard duck");
}

@end
