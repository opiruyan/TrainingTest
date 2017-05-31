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

@class HTPaymentManager;

@protocol HTPaymentManagerProtocol <NSObject>

- (void)paymentManager:(HTPaymentManager *)manager didRecieveCardData:(HTCardInfo *)cardInfo;

@end

@interface HTPaymentManager : NSObject <CardReaderDelegate>

@property (nonatomic, strong) id <HTPaymentManagerProtocol> delegate;

- (void)startEmvTransaction;
- (void)startMSRTransaction;
- (void)startKeyedTransactionWithAmount:(NSDecimalNumber *)amount
                                     cardNumber:(NSString *)carNumber
                                 expirationDate:(NSString *)expirationDate;
- (void)storeTicket:(NSString *)authCode;

@end
