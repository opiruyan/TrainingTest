//
//  HTSMSReceipt.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 09/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTSMSReceipt.h"

@implementation HTSMSReceipt

- (NSDictionary *)deserialize
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:self.to forKey:@"to"];
    [dict setObject:self.text forKey:@"body"];
    return dict;
}

@end
