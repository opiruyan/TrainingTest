//
//  HTPayment.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 16/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTPayment.h"
#import "HTTicket.h"
#import "HTWebProvider.h"
#import "HTSettings.h"

#define tillGuid @"77-1-010a20c8-d6ba-4846-9433-01bb911f2f56"
#define tenderName @"Credit"
#define tenderGuid @"77-244d943d-7306-4614-98ca-76048e1e487e"

@interface HTPayment ()

@property (nonatomic, strong) HTTicket *ticket;

@end

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

#warning should rework that
- (void)storeTicket:(NSDictionary *)ticketInfo
{
    self.ticket = [HTTicket ticketWithDictionary:ticketInfo];
    HTWebProvider *webProvider = [HTWebProvider sharedProvider];
    NSDictionary *dict = @{ @"locationId" : @77, @"employeeCreateGuid" : @"6d3d7393-eb38-44b7-b443-5626393f9d25", @"employeeOwnerGuid" : @"6d3d7393-eb38-44b7-b443-5626393f9d25", @"terminalNumber" : @1, @"orderNumber" : @([NSDate timeIntervalSinceReferenceDate]), @"businessDay" : [[NSDate date] description], @"amountPaid" : self.amount.stringValue, @"complete" : @1, @"completedAt" : [[NSDate date] description], @"discountTotal" : @0, @"grandTotal" : self.amount.stringValue, @"paymentTypeName" : @"Credit",
                            @"ticketPayments" : @[@{@"authCode" :self.ticket.authCode, @"employeeGuid" : @"6d3d7393-eb38-44b7-b443-5626393f9d25", @"receivedAmount" : @"2.4", @"paymentAmount" :  self.amount.stringValue, @"changeAmount" : @0, @"businessDay" : [[NSDate date] description], @"terminalNumber" : @1, @"gatewayStatus" : @0, @"tenderGuid" : tenderGuid, @"tenderName" : tenderName, @"tillGuid" : tillGuid, @"gatewayMessage" :self.ticket.gatewayMessage, @"gatewayId" : self.ticket.gatewayId, @"cardType" : self.ticket.cardType, @"cardLast4" : self.ticket.cardLast4, @"isAuthorized" : @1, @"isCredit" : @1, @"isFinalized" : @1, @"isValid" : @1}]};
    [webProvider POSTRequestToEndpoint:@"/api/v1/echo-pro/tickets/" body:dict withToken:[[[HTSettings sharedSettings] token] accessToken] completionHandler:^(NSData *data) {
        NSError *serializationError;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
        NSLog(@"%@", responseData);
    }];
}

@end
