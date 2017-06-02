//
//  HTMSRTransaction.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 31/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTMSRTransaction.h"
#import "HTTransaction_ProtectedProperties.h"
#import "HTOrderedMutableDictionary.h"
#import "HTPayment.h"

@interface HTMSRTransaction () <CardReaderTransactionFlowDelegate>

@end

@implementation HTMSRTransaction

-(instancetype)initWithDevice:(IDTechCardReaderManager *)deviceManager
{
    self = [super init];
    if (self)
    {
        self.cardReaderManager = deviceManager;
        [self.cardReaderManager setTransactionDelegate:self];
    }
    return self;
}

- (void)makeTransaction
{
    [self.cardReaderManager startMSRTransaction];
}

#pragma mark - Card Reader Delegate

- (void)gotEMVData:(IDTEMVData *)emvData
{
    if (emvData.cardData != nil)
    {
        [self didReadMSRData:emvData.cardData];
    }
}

- (void)didReadMSRData:(IDTMSRData *)cardData
{
    NSDictionary *msrRequestJSON = [self msrTransacrionJSONWithCardData:cardData];
    [self processTransactionWithData:msrRequestJSON withCompletion:^(NSDictionary *response) {
        NSLog(@"%@", response);
    }];
}

- (NSDictionary *)msrTransacrionJSONWithCardData:(IDTMSRData *)cardData
{
    NSString *ksn = cardData.KSN.description;
    ksn = [ksn stringByReplacingOccurrencesOfString:@"<" withString:@""];
    ksn = [ksn stringByReplacingOccurrencesOfString:@">" withString:@""];
    ksn = [ksn stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *track2 = cardData.encTrack2.description;
    track2 = [track2 stringByReplacingOccurrencesOfString:@"<" withString:@""];
    track2 = [track2 stringByReplacingOccurrencesOfString:@">" withString:@""];
    track2 = [track2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *track1 = cardData.encTrack1.description;
    track1 = [track1 stringByReplacingOccurrencesOfString:@"<" withString:@""];
    track1 = [track1 stringByReplacingOccurrencesOfString:@">" withString:@""];
    track1 = [track1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    HTOrderedMutableDictionary *dict = [HTOrderedMutableDictionary dictionary];
    [dict setObject:self.deviceId forKey:@"deviceID"];
    [dict setObject:self.transactionKey forKey:@"transactionKey"];
    [dict setObject:@"SWIPE" forKey:@"cardDataSource"];
    NSDecimalNumber *amount = [[HTPayment currentPayment] amount];
    [dict setObject:[NSString stringWithFormat:@"%.2f", amount.floatValue] forKey:@"transactionAmount"];
    [dict setValue:track1 forKey:@"track1Data"];
    [dict setValue:track2 forKey:@"track2Data"];
    if (cardData.captureEncryptType == CAPTURE_ENCRYPT_TYPE_TDES)
    {
        [dict setValue:@"TDES" forKey:@"encryptionType"];
    }
    else
    {
        [dict setValue:@"AES" forKey:@"encryptionType"];
    }
    
    [dict setValue:[ksn uppercaseString] forKey:@"ksn"];
    //    [dict setObject:@"MAGSTRIPE_READ_ONLY" forKey:@"terminalCapability"];
    //    [dict setObject:@"ON_MERCHANT_PREMISES_ATTENDED" forKey:@"terminalOperatingEnvironment"];
    //    [dict setObject:@"ELECTRONIC_SIGNATURE_ANALYSIS" forKey:@"cardholderAuthenticationMethod"];
    //    [dict setObject:@"SIGNATURE_ANALYSIS" forKey:@"terminalAuthenticationCapability"];
    //    [dict setObject:@"PRINT_AND_DISPLAY" forKey:@"terminalOutputCapability"];
    HTOrderedMutableDictionary *requestDictionary = [HTOrderedMutableDictionary dictionaryWithObject:dict forKey:@"Sale"];
    NSLog(@"%@", requestDictionary);
    return requestDictionary;
}



@end
