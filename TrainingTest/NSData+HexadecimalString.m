//
//  NSData+HexadecimalString.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 16/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "NSData+HexadecimalString.h"

@implementation NSData (HexadecimalString)

- (NSString *)hexadecimalString
{
    const unsigned char *bytes = (const unsigned char *)self.bytes;
    NSUInteger count = self.length;
    NSString *result = [NSString new];
    if (count > 0)
    {
        for (int i = 0; i < count; i++ )
        {
            result = [result stringByAppendingString:[NSString stringWithFormat:@"%02lx", (unsigned long)bytes[i]]];
        }
    }
    return result;
}

@end
