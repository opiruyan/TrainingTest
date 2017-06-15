//
//  HTPaymentManager.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 18/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTPaymentManager.h"
#import "IDTechCardReaderManager.h"
#import "HTMSRTransaction.h"
#import "HTKeyedTransaction.h"
#import "HTEMVTransaction.h"
#import "HTPayment.h"
#import "HTWebProvider.h"

@interface HTPaymentManager ()

@property (nonatomic, strong) IDTechCardReaderManager *cardReaderManager;
@property (nonatomic, strong) HTCardInfo *cardInfo;

@end

@implementation HTPaymentManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [[IDTechCardReaderManager sharedManager] setReaderDelegate:self];
    }
    return self;
}

- (IDTechCardReaderManager *)cardReaderManager
{
    return [IDTechCardReaderManager sharedManager];
}

- (void)startTransaction
{
    // since the same command is used to cancel both transaction types
    // it can be exectued here no matter if transaction type is gonna be changed
    [self stopTransaction];
    NSDecimalNumber *amount = [[HTPayment currentPayment] amount];
    if (self.emvTransationType)
    {
        [self.cardReaderManager startEmvTransactionWithAmount:amount];
    }
    else
    {
        [self.cardReaderManager startMSRTransaction];
    }
}

- (void)stopTransaction
{
    [[IDT_UniPayIII sharedController] ctls_cancelTransaction];;
}

#pragma mark - Reader Manager Delegate

- (void)readerManager:(IDTechCardReaderManager *)manager detectedDevicePlugged:(BOOL)status
{
    [self.delegate devicePlugged:status];
}

- (void)readerManager:(IDTechCardReaderManager *)manager didInitiateTransaction:(BOOL)success
{
    if (!success)
    {
        [self startTransaction];
    }
}

- (void)gotEMVData:(IDTEMVData *)emvData
{
    if (emvData.unencryptedTags.allKeys.count > 25)
    {
        [self.delegate paymentManager:self didRecieveCardData:nil];
        self.processingTransaction = [HTEMVTransaction transactionWithEmvData:emvData.unencryptedTags];
        // start transaction
        [self processTransactionWithCompletion:^(NSDictionary *response) {
            NSDictionary *saleResponse = [response objectForKey:@"SaleResponse"];
            BOOL result = [[saleResponse objectForKey:@"responseCode"] isEqualToString:@"A0000"];
            if (result)
            {
                // store payment to backend
                [[HTPayment currentPayment] storeTicket:saleResponse];
            };
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopTransaction];
                [self.delegate paymentManagerdidCompleteTransaction:result];
            });
        }];
    }
}

- (void)didReadMSRData:(IDTMSRData *)cardData
{
    [self.delegate paymentManager:self didRecieveCardData:nil];
    self.processingTransaction = [HTMSRTransaction transactionWithCardData:cardData];
    [self processTransactionWithCompletion:^(NSDictionary *response) {
        NSDictionary *saleResponse = [response objectForKey:@"SaleResponse"];
        BOOL result = [[saleResponse objectForKey:@"responseCode"] isEqualToString:@"A0000"];
        if (result)
        {
            [[HTPayment currentPayment] storeTicket:saleResponse];
        };
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopTransaction];
            [self.delegate paymentManagerdidCompleteTransaction:result];
        });
    }];
}


- (void)processTransactionWithCompletion:(transactionCompletionHandler)completion
{
    HTWebProvider *provider = [HTWebProvider sharedProvider];
    [provider paymentRequestWithData:self.processingTransaction.requestBody completion:^(NSData *data) {
        NSError *serializationError = nil;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
        if (serializationError == nil)
        {
            completion(responseData);
        }
    }];
}

@end
