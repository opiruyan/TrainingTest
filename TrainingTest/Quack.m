//
//  Quack.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/2/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "Quack.h"

@implementation Quack

- (void)performQuack
{
    NSLog(@"Quack");
}

@end

@implementation MuteQuack

- (void)performQuack
{
    NSLog(@"<<Silence>>");
}

@end

@implementation Squeak

- (void)performQuack
{
    NSLog(@"Squeak");
}

@end
