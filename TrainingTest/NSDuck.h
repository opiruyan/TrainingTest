//
//  NSDuck.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/2/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlyBehavior.h"
#import "QuackBehavior.h"

@interface NSDuck : NSObject

@property (nonatomic, strong) id <FlyBehavior> flyDelegate;
@property (nonatomic, strong) id <QuackBehavior> quackDelegate;

- (void)setFlyDelegate:(id<FlyBehavior>)flyDelegate;
- (void)setQuackDelegate:(id<QuackBehavior>)quackDelegate;

- (void)display;
- (void)fly;
- (void)quack;

@end
