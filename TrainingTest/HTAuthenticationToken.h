//
//  HTAuthenticationToken.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 26/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTAuthenticationToken : NSObject

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSString *tokenType;

+ (instancetype)tokenWithDicitonary:(NSDictionary *)dictionary;
+ (HTAuthenticationToken *)tokenFromKeychain;
- (void)save;

@end
