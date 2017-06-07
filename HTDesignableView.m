//
//  HTDesignableView.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 07/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTDesignableView.h"

@implementation HTDesignableView

- (void)drawRect:(CGRect)rect
{
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = self.borderWidth;
}

@end
