//
//  HTWebProvider+Settings.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 31/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTWebProvider.h"

@class HTAuthenticationToken;

@interface HTWebProvider (Settings)

@property (nonatomic, strong, readonly) HTAuthenticationToken *token;

@end
