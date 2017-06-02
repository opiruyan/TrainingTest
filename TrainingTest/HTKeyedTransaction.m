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

@implementation HTKeyedTransaction

- (void)makeTransaction
{
    NSDictionary *requestJSON = [self keyedTransactionRequestJSON];
    [self processTransactionWithData:requestJSON withCompletion:^(NSDictionary *data) {
        NSDictionary *saleResponse = [data objectForKey:@"SaleResponse"];
        //NSString *status = [[responseData objectForKey:@"SaleResponse"] objectForKey:@"FAIL"];
        if ([[saleResponse objectForKey:@"responseCode"] isEqualToString:@"A0000"])
        {
            // store payment to backend
            [[HTPayment currentPayment] storeTicket:saleResponse];
        };
    }];
}

- (NSDictionary *)keyedTransactionRequestJSON
{
    HTOrderedMutableDictionary *dict = [HTOrderedMutableDictionary dictionary];
    [dict setObject:@"88800000171001" forKey:@"deviceID"];
    [dict setObject:@"MXPNPOAG5FOFGIZJCSS1M4DFF4PQPXC4" forKey:@"transactionKey"];
    [dict setObject:@"MANUAL" forKey:@"cardDataSource"];
    [dict setObject:self.amount forKey:@"transactionAmount"];
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

@end