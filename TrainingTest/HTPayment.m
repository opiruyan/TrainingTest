//
//  HTPayment.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 16/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTPayment.h"

@implementation HTPayment

+ (id)sharedPayment
{
    static HTPayment *sharedPayment = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPayment = [[self alloc] init];
    });
    return sharedPayment;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _amount = [NSDecimalNumber zero];
    }
    return self;
}

+ (HTPayment *)currentPayment
{
    return [self sharedPayment];
}

@end
