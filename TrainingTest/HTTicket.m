//
//  HTTicket.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 01/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTTicket.h"

@implementation HTTicket

+ (HTTicket *)ticketWithDictionary:(NSDictionary *)dictionary
{
    return [[HTTicket alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dicionary
{
    self = [super init];
    if (self)
    {
        [self deserialize:dicionary];
    }
    return self;
}

- (void)deserialize:(NSDictionary *)dict
{
    _authCode = [dict objectForKey:@"authCode"];
    _customerReceipt = [dict objectForKey:@"customerReceipt"];
    _transactionId = [dict objectForKey:@"transactionID"];
    _timestamp = [dict objectForKey:@"transactionTimestamp"];
}

@end
