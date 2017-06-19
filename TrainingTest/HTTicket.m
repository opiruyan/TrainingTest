//
//  HTTicket.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 01/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTTicket.h"
#import "HTTicketPayment.h"

static NSString *const paymentTypeName =  @"Credit";
#warning should be taken from backend as master employee
static NSString *const employeeOwnerGuid =  @"6d3d7393-eb38-44b7-b443-5626393f9d25";

typedef enum {
    terminalNumber = 1,
    locationId = 5
} locationSettings;

#define discountTotal @0

@interface HTTicket ()

@property (strong, nonatomic) HTTicketPayment *ticketPayment;
@property (nonatomic, strong, readonly) NSString *customerReceipt;
@property (strong, nonatomic) NSString *totalAmount; //  in dollars
@property (strong, nonatomic) NSString *transactionAmount; // in cents
// Not clear what is the diference. Maybe transaction is an amount actually paid

@end

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
        [self serialize:dicionary];
    }
    return self;
}

- (void)serialize:(NSDictionary *)dict
{
    _customerReceipt = [dict objectForKey:@"customerReceipt"];
    _transactionAmount = [dict objectForKey:@"transactionAmount"];
    _totalAmount = [dict objectForKey:@"totalAmount"];
    _ticketPayment = [[HTTicketPayment alloc] initWithDictionary:dict];
}

- (NSDictionary *)deserialize
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:@(locationId) forKey:@"locationId"];
    [dict setValue:employeeOwnerGuid forKey:@"employeeCreateGuid"];
    [dict setValue:employeeOwnerGuid forKey:@"employeeOwnerGuid"];
    [dict setValue:@(terminalNumber) forKey:@"terminalNumber"];
    [dict setValue:@([NSDate timeIntervalSinceReferenceDate]) forKey:@"orderNumber"];
    [dict setValue:[[NSDate date] description] forKey:@"businessDay"];
    [dict setValue:self.totalAmount forKey:@"amountPaid"];
    [dict setValue:@1 forKey:@"complete"];
    [dict setValue:[[NSDate date] description] forKey:@"completedAt"];
    [dict setValue:@0 forKey:@"discountTotal"];
    [dict setValue:self.totalAmount forKey:@"grandTotal"];
    [dict setValue:paymentTypeName forKey:@"paymentTypeName"];
#warning looks awful
    [dict setValue:@[[self.ticketPayment deserialize]] forKey:@"ticketPayments"];
    return dict;
}

@end
