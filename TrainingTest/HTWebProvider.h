//
//  WebProvider.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 17/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTEmailReceipt, HTSMSReceipt;

typedef void (^completionHandler)(NSData *data);
typedef void (^paymentCompletion) (void);

@interface HTWebProvider : NSObject

+ (id)sharedProvider;
- (void)paymentRequestWithData:(NSDictionary *)paymentData completion:(completionHandler)completionBlock;
- (void)createNewTicketWithBody:(NSDictionary *)body;
- (void)sendEmail:(HTEmailReceipt *)email;
- (void)sendSms:(HTSMSReceipt *)sms;
- (void)exchangeCodeForToken:(NSString *)queryString WithCompletion:(completionHandler)completionBlock;
- (void)refreshToken:(NSDictionary *)body completionHandler:(completionHandler)completionBlock;

- (void)postRequestWithBody:(NSData *)body completionHandler:(completionHandler)completionBlock;

- (void)GETRequestToEndpoint:(NSString *)endpoint body:(NSData *)body withToken:(NSString *)token completionHandler:(completionHandler)completionBlock;
- (void)POSTRequestToEndpoint:(NSString *)endpoint body:(NSDictionary *)body withToken:(NSString *)token completionHandler:(completionHandler)completionBlock;


@end
