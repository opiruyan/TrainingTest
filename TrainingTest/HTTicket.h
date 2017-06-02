//
//  HTTicket.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 01/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTicket : NSObject

@property (nonatomic, strong, readonly) NSString *authCode;
@property (nonatomic, strong, readonly) NSString *customerReceipt;
@property (nonatomic, strong, readonly) NSString *transactionId;
@property (nonatomic, strong, readonly) NSString *timestamp;

+ (HTTicket *)ticketWithDictionary:(NSDictionary *)dictionary;

@end
