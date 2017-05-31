//
//  HTPaymentManager+transactionTypes.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 27/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTPaymentManager+transactionTypes.h"

@interface HTPaymentManager ()

@property (nonatomic, strong) NSArray *transactionTypes;

@end

@implementation HTPaymentManager (transactionTypes)

- (NSArray *)transactionTypes
{
    return @[@"Manual", @"Swipe", @"EMV"];
}

- (NSInteger)numberOfTransactions
{
    return self.transactionTypes.count;
}

- (NSString *)transactionTypeForNumber:(NSInteger)number
{
    return [self.transactionTypes objectAtIndex:number % 3];
}

@end
