//
//  HTTicketPayment.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 16/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTicketPayment : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary*)deserialize;

@end
