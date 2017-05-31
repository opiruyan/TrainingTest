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

@end
