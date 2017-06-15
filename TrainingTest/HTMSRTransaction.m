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
    [dict setObject:@"88800000171001" forKey:@"deviceID"];
    [dict setObject:@"MXPNPOAG5FOFGIZJCSS1M4DFF4PQPXC4" forKey:@"transactionKey"];
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
