//
//  HTTransaction.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 31/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^transactionCompletionHandler)(NSDictionary *response);

/**
 class for specifically TSYS transaction
*/
@interface HTTransaction : NSObject

@property (nonatomic, strong, readonly) NSDictionary *requestBody;

- (void)processTransactionWithData:(NSDictionary *)json withCompletion:(transactionCompletionHandler)completion;

@end
