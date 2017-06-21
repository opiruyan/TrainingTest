//
//  AppDelegate.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 3/30/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDTechCardReaderManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) IDTechCardReaderManager *cardReaderManager;


@end

