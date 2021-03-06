//
//  HTPaymentManager.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 18/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IDTech/IDTech.h>
#import "HTCardInfo.h"
#import "IDTechCardReaderManager.h"
#import "HTTransaction.h"

typedef enum
{
    htTransacionTypeEMV = 0,
    htTransacionTypeMSR,
    htTransacionTypeManual
} htTransationType;

@class HTPaymentManager;

@protocol HTPaymentManagerProtocol <NSObject>

- (void)paymentManager:(HTPaymentManager *)manager didRecieveCardData:(HTCardInfo *)cardInfo;
- (void)paymentManagerdidCompleteTransaction:(BOOL)result;

- (void)devicePlugged:(BOOL)status;

@end

@interface HTPaymentManager : NSObject <CardReaderDelegate>

@property (nonatomic, strong) id <HTPaymentManagerProtocol> delegate;
@property (nonatomic) BOOL emvTransationType;
@property (strong, nonatomic) HTTransaction *processingTransaction;

#warning add interface complying for cardReader
- (instancetype)initWithCardReader:(id)cardReader;
- (void)startTransaction;
- (void)stopTransaction;
- (void)processTransactionWithCompletion:(transactionCompletionHandler)completion;

@end
