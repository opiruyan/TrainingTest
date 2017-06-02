//
//  HTTransaction_ProtectedProperties.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 31/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#ifndef HTTransaction_ProtectedProperties_h
#define HTTransaction_ProtectedProperties_h

#import "IDTechCardReaderManager.h"

@interface HTTransaction ()

@property (strong, nonatomic) IDTechCardReaderManager *cardReaderManager;
@property (strong, nonatomic, readonly) NSString *deviceId;
@property (strong, nonatomic, readonly) NSString *transactionKey;

@property (strong, nonatomic, readonly) NSDecimalNumber *amount;
@property (strong, nonatomic, readonly) NSString *cardNumber;
@property (strong, nonatomic, readonly) NSString *expDate;

@end



#endif /* HTTransaction_ProtectedProperties_h */
