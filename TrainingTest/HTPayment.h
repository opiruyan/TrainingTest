//
//  HTPayment.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 16/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTCardInfo.h"

@class HTTransaction;

@interface HTPayment : NSObject

@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic ,strong) HTCardInfo *cardInfo;

+ (HTPayment *)currentPayment;
- (void)storeTicket:(NSDictionary *)ticketInfo;

@end
