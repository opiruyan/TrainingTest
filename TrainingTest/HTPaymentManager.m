//
//  HTPaymentManager.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 18/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTPaymentManager.h"
#import "HTPaymentManager+transactionInfoJSON.h"
#import "HTPaymentManager+transactionTypes.h"
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
    if (self.emvTransationType)
    {
        [[IDT_UniPayIII sharedController] ctls_cancelTransaction];;
    }
    else
    {
        [self.cardReaderManager cancelMSR];
    }
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
            [self.cardReaderManager cancelMSR];
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

#pragma mark - Utils

- (HTCardInfo *)parseTrack1:(NSString *)track
{
    if (track.length == 0)
    {
        return nil;
    }
    NSRegularExpression *testExpression = [NSRegularExpression regularExpressionWithPattern:@"\\d{2,}|[a-zA-Z]{2,}"
                                                                                    options:NSRegularExpressionCaseInsensitive
                                                                                      error:nil];
    NSArray *matches = [testExpression matchesInString:track
                                               options:0
                                                 range:NSMakeRange(0, [track length])];
    NSMutableArray *components = [NSMutableArray array];
    [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL *stop) {
        for (int i = 0; i < [obj numberOfRanges]; i++)
        {
            NSRange range = [obj rangeAtIndex:i];
            NSString *string = [track substringWithRange:range];
            [components addObject: string];
        }
    }];
    HTCardInfo *cardInfo = [HTCardInfo new];
    cardInfo.firstName = components[1];
    cardInfo.lastName = components[2];
    cardInfo.cardNumber = components[0];
    cardInfo.expDate = [components lastObject];
    return cardInfo;
}

@end
