//
//  HTPaymentManager+transactionTypes.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 27/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTPaymentManager.h"

typedef enum
{
    htTransacionTypeManual = 0,
    htTransacionTypeMSR,    
    htTransacionTypeEMV
} htTransationType;

@interface HTPaymentManager (transactionTypes)

- (NSInteger)numberOfTransactions;
- (NSString *)transactionTypeForNumber:(NSInteger)numeber;

@end
