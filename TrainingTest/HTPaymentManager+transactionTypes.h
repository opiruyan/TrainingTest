//
//  HTPaymentManager+transactionTypes.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 27/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTPaymentManager.h"

@interface HTPaymentManager (transactionTypes)

- (NSInteger)numberOfTransactions;
- (NSString *)transactionTypeForNumber:(NSInteger)numeber;

@end
