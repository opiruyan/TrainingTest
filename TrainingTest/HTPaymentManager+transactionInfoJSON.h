//
//  HTPaymentManager+transactionInfoJSON.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 26/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTPaymentManager.h"

@class IDTMSRData;

@interface HTPaymentManager (transactionInfoJSON)

- (NSDictionary *)keyedTransactionRequestJSONWithAmount:(NSString *)amount cardNumber:(NSString *)cardNumber expDate:(NSString *)expdate;
- (NSDictionary *)msrTransacrionJSONWithAmount:(NSString *)amount cardData:(IDTMSRData *)cardData;
- (NSDictionary *)emvTransactionJSONWithEMVTags:(NSDictionary *)emvTagsDictionary;

@end
