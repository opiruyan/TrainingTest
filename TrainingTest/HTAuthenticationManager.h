//
//  HTAuthenticationManager.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 03/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kHandlingURLNotification;

@interface HTAuthenticationManager : NSObject

+ (id)sharedManager;
- (void)refreshToken;
- (BOOL)authorized;

@end
