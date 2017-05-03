//
//  NSString+SHA256.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 25/04/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "NSString+SHA256.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (SHA256)


+ (NSString *)doSha256:(NSString *)input
{
    unsigned char codedString[CC_SHA256_DIGEST_LENGTH];
    const char *testChar = [input UTF8String];
    CC_SHA256(testChar, (CC_LONG)strlen(testChar), codedString);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",codedString[i]];
    }
    return ret;
}

@end
