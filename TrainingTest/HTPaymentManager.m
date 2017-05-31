//
//  HTPaymentManager.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 18/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTPaymentManager.h"
#import "HTTSYSManager.h"
#import "HTPayment.h"
#import "NSData+HexadecimalString.h"
#import "HTWebProvider.h"
#import "HTPaymentManager+transactionInfoJSON.h"
#import "HTPaymentManager+transactionTypes.h"
#import "HTMSRTransaction.h"

typedef void (^transactionCompletionHandler)(NSData *data);

@interface HTPaymentManager ()

@property (strong, nonatomic) IDTechCardReaderManager *cardReaderManager;
@property (nonatomic, strong) HTTSYSManager *processingManager;
@property (nonatomic, strong) HTCardInfo *cardInfo;
@property (copy, nonatomic) transactionCompletionHandler transactionHandler;

@end

@implementation HTPaymentManager

- (IDTechCardReaderManager *)cardReaderManager
{
    if (!_cardReaderManager)
    {
        _cardReaderManager = [[IDTechCardReaderManager alloc] init];
        _cardReaderManager.transactionDelegate = self;
    }
    return _cardReaderManager;
}

-(HTTSYSManager *)processingManager
{
    if (!_processingManager)
    {
        _processingManager = [[HTTSYSManager alloc] init];
    }
    return _processingManager;
}

- (transactionCompletionHandler)transactionHandler
{
    __weak typeof(self) weakSelf = self;
    return ^(NSData *data) {
        NSError *serializationError;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
        NSString *status = [[responseData objectForKey:@"SaleResponse"] objectForKey:@"FAIL"];
        if ([responseData objectForKey:@"SaleResponse"])
        {
            // store payment to backend
            NSString *transactionId = [[responseData objectForKey:@"SaleResponse"] objectForKey:@"authCode"];
            [weakSelf storeTicket:transactionId];
        };
    };
}

#pragma mark - Payment

- (void)startMSRTransaction
{
    [self.cardReaderManager startMSRTransaction];
}

- (void)startEmvTransaction
{
    [self.cardReaderManager startEmvTransactionWithAmount:[[HTPayment currentPayment] amount]];

}

- (void)startKeyedTransactionWithAmount:(NSDecimalNumber *)amount
                             cardNumber:(NSString *)carNumber
                         expirationDate:(NSString *)expirationDate
{
    NSDictionary *requestJSON = [self keyedTransactionRequestJSONWithAmount:[amount stringValue] cardNumber:carNumber expDate:expirationDate];
    [self.processingManager performSaleRequestWithData:requestJSON completion:self.transactionHandler];
}


/**
 method to be called after card reader processed reading card information. Now payment can be made.
 */
- (void)gotEMVData:(IDTEMVData *)emvData
{
    //[self.delegate paymentManager:self didRecieveCardData:[self parseTrack1:cardData.track1]];
    [self performEMVPaymentWithData:emvData];
}

- (void)didReadMSRData:(IDTMSRData *)cardData
{
    [self performMSRPaymentWithData:cardData];
}

- (void)performMSRPaymentWithData:(IDTMSRData *)cardData
{
    NSDictionary *msrRequestJSON = [self msrTransacrionJSONWithAmount:[[[HTPayment currentPayment] amount] stringValue] cardData:cardData];
    [self.processingManager performSaleRequestWithData:msrRequestJSON completion:self.transactionHandler];
}

- (void)performEMVPaymentWithData:(IDTEMVData *)emvData
{
    NSDictionary *emvRequestJSON = [self emvTransactionJSONWithEMVTags:emvData.unencryptedTags];
    [self.processingManager performSaleRequestWithData:emvRequestJSON completion:self.transactionHandler];
}


- (void)storeTicket:(NSString *)authCode
{
//    HTWebProvider *webProvider = [HTWebProvider sharedProvider];
//    NSDictionary *dict = @{ @"locationId" : @77, @"employeeCreateGuid" : @"6d3d7393-eb38-44b7-b443-5626393f9d25", @"employeeOwnerGuid" : @"6d3d7393-eb38-44b7-b443-5626393f9d25", @"terminalNumber" : @1, @"orderNumber" : @([NSDate timeIntervalSinceReferenceDate]), @"businessDay" : [[NSDate date] description], @"ticketPayments" : @[@{@"authCode" : authCode,@"employeeGuid" : @"6d3d7393-eb38-44b7-b443-5626393f9d25", @"receivedAmount" : @"2.4", @"paymentAmount" : @"2.4", @"changeAmount" : @0, @"businessDay" : [[NSDate date] description], @"terminalNumber" : @1, @"gatewayStatus" : @0, @"tenderGuid" : @"fair trade", @"tenderName" : @"sell some oil, buy some iphones", @"tillGuid" : @"v1ln14s"}]};
//    [webProvider POSTRequestToEndpoint:@"/api/v1/echo-pro/tickets/" body:dict withToken:authManager.token completionHandler:^(NSData *data) {
//        NSError *serializationError;
//        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
//        if ([responseData objectForKey:@"error"])
//        {
//            if ([[[responseData objectForKey:@"error"] objectForKey:@"message"] isEqualToString:@"invalid token"])
//            {
//                [authManager refreshToken];
//            }
//        }
//    }];
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
