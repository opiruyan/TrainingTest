//
//  HTTSYSManager.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 05/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTTSYSManager.h"
#import "HTPayment.h"
#import "HTTransaction.h"
#import "HTTSYSManager+RequestJSONs.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <IDTech/IDTech.h>

@interface HTTSYSManager ()

@end

@implementation HTTSYSManager

- (void)performSaleRequestWithData:(NSDictionary *)emvData completion:(completionHandler)completion
{
    HTWebProvider *provider = [HTWebProvider sharedProvider];
    [provider paymentRequestWithData:emvData completion:^(NSData *data) {
        NSError *serializationError;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
        if ([[responseData objectForKey:@"status"] isEqualToString:@"PASS"])
        {
            HTPayment *currentPayment = [HTPayment currentPayment];
            currentPayment.transaction = [HTTransaction transactionWithDictionary:responseData];
#warning duplicating callback
            completion(data);
        }
        completion(data);
        NSLog(@"%@", responseData);
    }];
}

- (void)performVoidRequest
{
    NSDictionary *requestDictionary = [self dictionaryVoidRequest];
    HTWebProvider *provider = [HTWebProvider sharedProvider];
    [provider paymentRequestWithData:requestDictionary completion:^(NSData *data) {
        NSError *serializationError;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
        if ([[responseData objectForKey:@"status"] isEqualToString:@"PASS"])
        {
            HTPayment *currentPayment = [HTPayment currentPayment];
            currentPayment.transaction = [HTTransaction transactionWithDictionary:responseData];
        }
        NSLog(@"%@", responseData);
    }];
}


@end
