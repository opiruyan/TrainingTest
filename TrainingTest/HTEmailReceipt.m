//
//  HTEmailReceipt.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 25/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTEmailReceipt.h"

@implementation HTEmailReceipt

- (NSDictionary *)deserialize
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:self.from forKey:@"from"];
    [dict setObject:self.to forKey:@"to"];
    [dict setObject:self.subject forKey:@"subject"];
    [dict setObject:self.text forKey:@"text"];
    return dict;
}

@end
