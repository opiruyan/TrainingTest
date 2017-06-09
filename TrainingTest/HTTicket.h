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
@property (nonatomic, strong, readonly) NSString *gatewayId;
@property (nonatomic, strong, readonly) NSString *timestamp;
@property (nonatomic, strong, readonly) NSString *cardType;
@property (nonatomic, strong, readonly) NSString *cardLast4;
@property (nonatomic, strong, readonly) NSString *gatewayMessage;

+ (HTTicket *)ticketWithDictionary:(NSDictionary *)dictionary;

@end
