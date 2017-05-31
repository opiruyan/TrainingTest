//
//  HTWebProvider+Settings.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 31/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTWebProvider+Settings.h"
#import "HTSettings.h"

@implementation HTWebProvider (Settings)

- (HTAuthenticationToken *)token
{
    return [[HTSettings sharedSettings] token];
}

@end
