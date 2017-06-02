//
//  HTTransaction.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 31/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^transactionCompletionHandler)(NSDictionary *response);

@interface HTTransaction : NSObject

- (void)makeTransaction;
- (void)processTransactionWithData:(NSDictionary *)json withCompletion:(transactionCompletionHandler)completion;

@end
