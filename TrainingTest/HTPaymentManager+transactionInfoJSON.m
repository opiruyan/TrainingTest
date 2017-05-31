//
//  HTPaymentManager+transactionInfoJSON.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 26/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTPaymentManager+transactionInfoJSON.h"
#import "HTOrderedMutableDictionary.h"
#import "NSData+HexadecimalString.h"

#define transactionKey @"MXPNPOAG5FOFGIZJCSS1M4DFF4PQPXC4"
#define deveiceID @"88800000171001"
//#define transactionKey @"69CJPCYADTFLAID9I5Y0YAR1I4MOD9K0"
//#define deveiceID @"00002082172201"

@implementation HTPaymentManager (transactionInfoJSON)

- (NSDictionary *)keyedTransactionRequestJSONWithAmount:(NSString *)amount cardNumber:(NSString *)cardNumber expDate:(NSString *)expdate
{
    HTOrderedMutableDictionary *dict = [HTOrderedMutableDictionary dictionary];
    [dict setObject:deveiceID forKey:@"deviceID"];
    [dict setObject:transactionKey forKey:@"transactionKey"];
    [dict setObject:@"MANUAL" forKey:@"cardDataSource"];
    [dict setObject:amount forKey:@"transactionAmount"];
    [dict setObject:@"5469420014586922" forKey:@"cardNumber"];
    [dict setObject:@"1117" forKey:@"expirationDate"];
    [dict setObject:@"Oleg" forKey:@"firstName"];
    [dict setObject:@"KEYED_ENTRY_ONLY" forKey:@"terminalCapability"];
    [dict setObject:@"ON_MERCHANT_PREMISES_ATTENDED" forKey:@"terminalOperatingEnvironment"];
    [dict setObject:@"ELECTRONIC_SIGNATURE_ANALYSIS" forKey:@"cardholderAuthenticationMethod"];
    [dict setObject:@"SIGNATURE_ANALYSIS" forKey:@"terminalAuthenticationCapability"];
    [dict setObject:@"PRINT_AND_DISPLAY" forKey:@"terminalOutputCapability"];
    HTOrderedMutableDictionary *requestDictionary = [HTOrderedMutableDictionary dictionaryWithObject:dict forKey:@"Sale"];
    NSLog(@"%@", requestDictionary);
    return requestDictionary;
}

- (NSDictionary *)msrTransacrionJSONWithAmount:(NSString *)amount cardData:(IDTMSRData *)cardData
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
    [dict setObject:deveiceID forKey:@"deviceID"];
    [dict setObject:transactionKey forKey:@"transactionKey"];
    [dict setObject:@"SWIPE" forKey:@"cardDataSource"];
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

- (NSDictionary *)emvTransactionJSONWithEMVTags:(NSDictionary *)emvTagsDictionary
{
    HTOrderedMutableDictionary *dict = [HTOrderedMutableDictionary dictionary];
    [dict setObject:deveiceID forKey:@"deviceID"];
    [dict setObject:transactionKey forKey:@"transactionKey"];
    [dict setObject:@"EMV" forKey:@"cardDataSource"];
    [dict setObject:@"308" forKey:@"transactionAmount"];
    
    NSArray *tagsArray = [self emvTagsFromDictionary:emvTagsDictionary];
    [dict setObject:@{@"tag" : tagsArray} forKey:@"emvTags"];
    
    [dict setObject:@"1.8.4" forKey:@"paymentAppVersion"];
    [dict setObject:@"Oleg" forKey:@"firstName"];
    [dict setObject:@"ICC_CHIP_CONTACT_CONTACTLESS" forKey:@"terminalCapability"];
    [dict setObject:@"ON_MERCHANT_PREMISES_ATTENDED" forKey:@"terminalOperatingEnvironment"];
    [dict setObject:@"NOT_AUTHENTICATED" forKey:@"cardholderAuthenticationMethod"];
    [dict setObject:@"NO_CAPABILITY" forKey:@"terminalAuthenticationCapability"];
    [dict setObject:@"PRINT_AND_DISPLAY" forKey:@"terminalOutputCapability"];
    [dict setObject:@"NOT_SUPPORTED" forKey:@"maxPinLength"];
    HTOrderedMutableDictionary *requestDictionary = [HTOrderedMutableDictionary dictionaryWithObject:dict forKey:@"Sale"];
    NSLog(@"%@", requestDictionary);
    return requestDictionary;
}

- (NSArray *)emvTagsFromDictionary:(NSDictionary *)emvTagsDictionary
{
    NSMutableArray *paymentEmvTags = [NSMutableArray arrayWithArray:[self tlvTagsWithEmvTags:emvTagsDictionary]];
    [paymentEmvTags addObject:@"5F2A020840"]; // ISO 4217 currency code for us dollar
    [paymentEmvTags addObject:[NSString stringWithFormat:@"9A03%@", [self currentTransactionDate]]]; // Transaction Date tag
    [paymentEmvTags addObject:@"9C0100"]; // Transaction type : two digits of ISO 8583 Processing code
    [paymentEmvTags addObject:@"9F1A020840"]; // Terminal Country Code ISO 3166-1
    [paymentEmvTags addObject:@"82025800"]; // Application Interchange profile
    [paymentEmvTags addObject:@"9F3303E0F8C8"]; // Terminal capabilities
    [paymentEmvTags addObject:@"50104D617374657243617264202020202020"]; // Applicaion Label (master card i.e.)
    [paymentEmvTags addObject:@"DF78083731353739393939"]; // (TSYS Sierra tag) Device Serial Number
    [paymentEmvTags addObject:@"DF790430333733"]; // (TSYS Sierra tag) Kernel Version Number
    
    //    [dict setObject:@{@"tag" : @[@"95050000048000", @"9C0100", @"9F3303E0F8C8", @"5F2403251231", @"5F340100", @"9F10120212A0000F240000DAC000000000000000FF", @"9F1A020840", @"9F2608A8B37B4B13D20E35", @"9F270180", @"9F3403420300", @"9F36020002", @"9F3704FA621AF0", @"82025800", @"9A03151019", @"9F02060000000046000", @"4F07A0000000041010", @"5F2011496E7465726F7065722E20303920313341", @"50104D617374657243617264202020202020", @"5F2A020840", @"DF78083731353739393939", @"DF790430333733", @"57135469420014586922d17112010144600000562f", @"5f200c5049525559414e2f4f4c4547" /*@"57114761739001010010D15122011143804489"*/]} forKey:@"emvTags"];
    
    return paymentEmvTags;
}

#pragma mark - Utils

- (NSString *)currentTransactionDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMdd"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

/**
 transforms dictionary of emv tags to array of tags in TLV(tag-length-value) format
 @param emvTags - dicitonary of pairs: tag = <value>
 */
- (NSArray *)tlvTagsWithEmvTags:(NSDictionary *)emvTags
{
    // delete tag 9F02 of amount of the transaction
    NSMutableDictionary *tagsDictionary = [NSMutableDictionary dictionaryWithDictionary:emvTags];
    [tagsDictionary removeObjectForKey:@"9F02"];
    NSMutableArray *tlvTagsArray = [NSMutableArray new];
    for (NSString *key in emvTags)
    {
        NSData *tagValue = [emvTags objectForKey:key];
        if (tagValue.length > 0)
        {
            NSString *value = [tagValue hexadecimalString];
            NSString *length = [NSString stringWithFormat:@"%02lx", (unsigned long)tagValue.length];
            [tlvTagsArray addObject:[NSString stringWithFormat:@"%@%@%@", key, length, value]];
        }
    }
    return tlvTagsArray;
}



@end
