//
//  HTTransaction.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 31/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTTransaction.h"
#import "IDTechCardReaderManager.h"
#import "HTSettings.h"
#import "HTWebProvider.h"
#import "HTTransaction_ProtectedProperties.h"
#import "HTPayment.h"


@implementation HTTransaction

- (transactionCompletionHandler)transactionHandler
{
    return ^(NSDictionary *data) {
        NSDictionary *saleResponse = [data objectForKey:@"SaleResponse"];
        //NSString *status = [[responseData objectForKey:@"SaleResponse"] objectForKey:@"FAIL"];
        if ([[saleResponse objectForKey:@"responseCode"] isEqualToString:@"A0000"])
        {
            // store payment to backend
            [[HTPayment currentPayment] storeTicket:saleResponse];
        };
    };
}

- (NSString *)deviceId
{
    return [[HTSettings sharedSettings] tsysDeviceId];
}

- (NSString *)transactionKey
{
    return [[HTSettings sharedSettings] tsysTransactionKey];
}

- (NSDecimalNumber *)amount
{
    return [[HTPayment currentPayment] amount];
}

- (NSString *)cardNumber
{
    return  [[[HTPayment currentPayment] cardInfo] cardNumber];
}

- (NSString *)expDate
{
    return  [[[HTPayment currentPayment] cardInfo] expDate];
}

- (void)processTransactionWithData:(NSDictionary *)json withCompletion:(transactionCompletionHandler)completion
{
    HTWebProvider *provider = [HTWebProvider sharedProvider];
    [provider paymentRequestWithData:json completion:^(NSData *data) {
        NSError *serializationError = nil;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
        if (serializationError == nil)
        {
            completion(responseData);
        }
    }];
}


@end
