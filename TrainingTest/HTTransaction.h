//
//  HTTransaction.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 17/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTransaction : NSObject

@property (nonatomic, strong) NSString *transactionID;
@property (nonatomic, strong) NSString *transactionTimestamp;
@property (nonatomic, strong) NSString *authCode;
@property (nonatomic, strong) NSString *totalAmount;


+ (id)transactionWithDictionary:(NSDictionary *)dictionary;


@end
