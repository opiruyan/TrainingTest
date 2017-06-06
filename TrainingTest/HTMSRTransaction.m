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
#import "NSData+HexadecimalString.h"

@interface HTMSRTransaction ()

@property (nonatomic, strong) NSString *ksn;
@property (nonatomic, strong) NSString *track1;
@property (nonatomic, strong) NSString *track2;
@property (nonatomic, strong) NSString *encryptionType;

@end

@implementation HTMSRTransaction

+ (HTMSRTransaction *)transactionWithCardData:(IDTMSRData *)cardData
{
    return [[HTMSRTransaction alloc] initWithCardData:cardData];
}

- (instancetype)initWithCardData:(IDTMSRData *)cardData
{
    self = [super init];
    if (self)
    {
        _ksn = [cardData.KSN hexadecimalString];
        _track1 = [cardData.encTrack1 hexadecimalString];
        _track2 = [cardData.encTrack2 hexadecimalString];
        if (cardData.captureEncryptType == CAPTURE_ENCRYPT_TYPE_TDES)
        {
            _encryptionType = @"TDES";
        }
        else
        {
            _encryptionType = @"AES";
        }

    }
    return self;
}

- (NSDictionary *)requestBody
{
    HTOrderedMutableDictionary *dict = [HTOrderedMutableDictionary dictionary];
    [dict setObject:self.deviceId forKey:@"deviceID"];
    [dict setObject:self.transactionKey forKey:@"transactionKey"];
    [dict setObject:@"SWIPE" forKey:@"cardDataSource"];
    NSDecimalNumber *amount = [[HTPayment currentPayment] amount];
    [dict setObject:[NSString stringWithFormat:@"%.2f", amount.floatValue] forKey:@"transactionAmount"];
    [dict setValue:_track1 forKey:@"track1Data"];
    [dict setValue:_track2 forKey:@"track2Data"];
    [dict setValue:_encryptionType forKey:@"encryptionType"];
    [dict setValue:[_ksn uppercaseString] forKey:@"ksn"];
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
