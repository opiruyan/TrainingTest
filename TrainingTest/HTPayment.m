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
#import "HTWebProvider+Settings.h"

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
    NSDictionary *dict =  [self.ticket deserialize];
    [webProvider POSTRequestToEndpoint:@"/api/v1/echo-pro/tickets/" body:dict withToken:webProvider.token.accessToken completionHandler:^(NSData *data) {
        NSError *serializationError;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
        NSLog(@"%@", responseData);
    }];
}

@end
