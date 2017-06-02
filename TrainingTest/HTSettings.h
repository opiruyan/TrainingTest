//
//  HTSettings.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 31/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTAuthenticationToken.h"

@interface HTSettings : NSObject

+ (id)sharedSettings;
- (void)saveAuthenticationToken:(NSDictionary *)tokenDictionary;

@property (nonatomic, strong) HTAuthenticationToken *token;
@property (nonatomic, strong, readonly) NSString *host;

// tsys credentials
@property (nonatomic, strong) NSString *tsysDeviceId;
@property (nonatomic, strong) NSString *tsysTransactionKey;
@property (nonatomic, strong) NSString *tsysMerchantId;
@property (nonatomic, strong) NSString *tsysServerUrl;

@end
