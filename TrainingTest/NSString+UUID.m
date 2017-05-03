//
//  NSString+UUID.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 25/04/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "NSString+UUID.h"

@implementation NSString (UUID)

+ (NSString *)UUIDString
{
    return [[[NSUUID UUID] UUIDString] lowercaseString];
}


@end
