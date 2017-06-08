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

//- (void)paymentManager:(HTPaymentManager *)manager didRecieveCardData:(HTCardInfo *)cardInfo;
- (void)paymentManagerdidCompleteTransaction:(HTPaymentManager *)manager;

- (void)devicePlugged:(BOOL)status;

@end

@interface HTPaymentManager : NSObject <CardReaderDelegate>

@property (nonatomic, strong) id <HTPaymentManagerProtocol> delegate;
@property (nonatomic) htTransationType transationType;
@property (strong, nonatomic) HTTransaction *processingTransaction;

- (void)startTransaction;

@end
