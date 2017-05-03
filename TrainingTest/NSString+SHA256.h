//
//  NSString+SHA256.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 25/04/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SHA256)

+ (NSString *)doSha256:(NSString *)input;

@end
