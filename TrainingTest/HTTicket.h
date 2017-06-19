//
//  HTTicket.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 01/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTicket : NSObject

+ (HTTicket *)ticketWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)deserialize;

@end
