//
//  HTTicketPayment.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 16/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTTicketPayment.h"

static NSString *const employeeOwnerGuid =  @"123";
static NSString *const tillGuid = @"426b4c87-7923-45b9-9a49-353c8a1e24b0";
static NSString *const tenderName =  @"Credit";
static NSString *const tenderGuid = @"5-12-4397ab1e-9297-4db7-a542-74f1620a0280";

@interface HTTicketPayment ()

@property (nonatomic, strong, readonly) NSString *authCode;
@property (strong, nonatomic) NSString *totalAmount;
@property (strong, nonatomic) NSString *transactionAmount;
@property (strong, nonatomic) NSString *transactionTimestamp;
@property (nonatomic, strong) NSString *gatewayMessage;
@property (nonatomic, strong) NSString *gatewayId;
@property (nonatomic, strong) NSString *cardType;
@property (nonatomic, strong) NSString *cardLast4;

@end

@implementation HTTicketPayment

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        [self serialize:dictionary];
    }
    return self;
}

- (void)serialize:(NSDictionary *)dict
{
    _authCode = [dict objectForKey:@"authCode"];
    _transactionAmount = [dict objectForKey:@"transactionAmount"];
    _totalAmount = [dict objectForKey:@"totalAmount"];
    _transactionTimestamp = [dict objectForKey:@"transactionTimestamp"];
    _gatewayMessage = [dict objectForKey:@"responseMessage"];
    _gatewayId = [dict objectForKey:@"transactionID"];
    _cardType = [dict objectForKey:@"cardType"];
    _cardLast4 = [dict objectForKey:@"maskedCardNumber"];
}

- (NSDictionary*)deserialize
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:self.authCode forKey:@"authCode"];
    [dictionary setObject:employeeOwnerGuid forKey:@"employeeGuid"];
    [dictionary setValue:self.transactionAmount forKey:@"receivedAmount"];
    [dictionary setValue:self.totalAmount forKey:@"paymentAmount"];
    [dictionary setValue:@0 forKey:@"changeAmount"];
    [dictionary setValue:self.transactionTimestamp forKey:@"businessDay"];
    [dictionary setValue:@1 forKey:@"terminalNumber"];
    [dictionary setValue:@0 forKey:@"gatewayStatus"];
    [dictionary setValue:tenderGuid forKey:@"tenderGuid"];
    [dictionary setValue:tenderName forKey:@"tenderName"];
    [dictionary setValue:tillGuid forKey:@"tillGuid"];
    [dictionary setValue:self.gatewayMessage forKey:@"gatewayMessage"];
    [dictionary setValue:self.gatewayId forKey:@"gatewayId"];
    [dictionary setValue:self.cardType forKey:@"cardType"];
    [dictionary setValue:self.cardLast4 forKey:@"cardLast4"];
    [dictionary setValue:@1 forKey:@"isAuthorized"];
    [dictionary setValue:@1 forKey:@"isCredit"];
    [dictionary setValue:@1 forKey:@"isFinalized"];
    [dictionary setValue:@1 forKey:@"isValid"];
    return dictionary;
}

@end
