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

@interface HTPaymentManager ()

@property (nonatomic, strong) IDTechCardReaderManager *cardReaderManager;
@property (nonatomic, strong) HTCardInfo *cardInfo;

@end

@implementation HTPaymentManager

- (IDTechCardReaderManager *)cardReaderManager
{
    if (!_cardReaderManager)
    {
        _cardReaderManager = [[IDTechCardReaderManager alloc] init];
        _cardReaderManager.readerDelegate = self;
        [[IDT_UniPayIII sharedController] setDelegate:_cardReaderManager];
    }
    return _cardReaderManager;
}

- (void)setProcessingTransactionOfTransactiontype:(htTransationType)transactionType
{
    switch (transactionType)
    {
        case htTransacionTypeManual:
            self.processingTransaction = [HTKeyedTransaction new];
            break;
        case htTransacionTypeEMV:
            self.processingTransaction = [[HTEMVTransaction alloc] initWithDevice:self.cardReaderManager];
            break;
        case htTransacionTypeMSR:
            self.processingTransaction = [[HTMSRTransaction alloc] initWithDevice:self.cardReaderManager];
            break;
        default:
            break;
    }
}

#pragma mark - Reader Manager Delegate

- (void)readerManager:(IDTechCardReaderManager *)manager detectedDevicePlugged:(BOOL)status
{
    [self.delegate devicePlugged:status];
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
