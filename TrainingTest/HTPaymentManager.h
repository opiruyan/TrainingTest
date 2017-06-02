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
    htTransacionTypeManual = 0,
    htTransacionTypeMSR,
    htTransacionTypeEMV
} htTransationType;

@class HTPaymentManager;

@protocol HTPaymentManagerProtocol <NSObject>

- (void)paymentManager:(HTPaymentManager *)manager didRecieveCardData:(HTCardInfo *)cardInfo;

- (void)devicePlugged:(BOOL)status;

@end

@interface HTPaymentManager : NSObject <CardReaderStateDelegate>

@property (nonatomic, strong) id <HTPaymentManagerProtocol> delegate;
@property (strong, nonatomic) HTTransaction *processingTransaction;

- (void)setProcessingTransactionOfTransactiontype:(htTransationType)transactionType;
- (void)storeTicket:(NSString *)authCode;

@end
