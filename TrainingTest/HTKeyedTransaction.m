//
//  HTKeyedTransaction.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 31/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTKeyedTransaction.h"
#import "HTPayment.h"
#import "HTOrderedMutableDictionary.h"
#import "HTTransaction_ProtectedProperties.h"

@interface HTKeyedTransaction ()

@property (nonatomic, strong) HTCardInfo *cardData;

@end

@implementation HTKeyedTransaction

- (instancetype)initWithCardData:(HTCardInfo *)cardData
{
    self = [super init];
    if (self)
    {
        self.cardData = cardData;
    }
    return self;
}

- (NSDictionary *)requestBody
{
    HTOrderedMutableDictionary *dict = [HTOrderedMutableDictionary dictionary];
    [dict setObject:@"88800000171001" forKey:@"deviceID"];
    [dict setObject:@"MXPNPOAG5FOFGIZJCSS1M4DFF4PQPXC4" forKey:@"transactionKey"];
    [dict setObject:@"MANUAL" forKey:@"cardDataSource"];
    [dict setObject:[NSString stringWithFormat:@"%.2f", self.amount.floatValue] forKey:@"transactionAmount"];
    [dict setValue:self.cardData.cardNumber forKey:@"cardNumber"];
    [dict setValue:self.cardData.expDate forKey:@"expirationDate"];
    [dict setObject:@"KEYED_ENTRY_ONLY" forKey:@"terminalCapability"];
    [dict setObject:@"ON_MERCHANT_PREMISES_ATTENDED" forKey:@"terminalOperatingEnvironment"];
    [dict setObject:@"ELECTRONIC_SIGNATURE_ANALYSIS" forKey:@"cardholderAuthenticationMethod"];
    [dict setObject:@"SIGNATURE_ANALYSIS" forKey:@"terminalAuthenticationCapability"];
    [dict setObject:@"PRINT_AND_DISPLAY" forKey:@"terminalOutputCapability"];
    HTOrderedMutableDictionary *requestDictionary = [HTOrderedMutableDictionary dictionaryWithObject:dict forKey:@"Sale"];
    NSLog(@"%@", requestDictionary);
    return requestDictionary;
}

@end
