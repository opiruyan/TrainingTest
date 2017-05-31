//
//  HTTransaction.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 17/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTTransaction.h"

@implementation HTTransaction

+ (id)transactionWithDictionary:(NSDictionary *)dictionary
{
    return [[HTTransaction alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        [self serializeFromDictionary:dictionary];
    }
    return self;
}

- (void)serializeFromDictionary:(NSDictionary *)dictionary
{
    _transactionID = [dictionary objectForKey:@"transactionID"];
    _transactionTimestamp = [dictionary objectForKey:@"transactionTimestamp"];
}

@end
