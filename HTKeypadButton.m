//
//  HTKeypadButton.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 07/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTKeypadButton.h"

@implementation HTKeypadButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = self.borderColor.CGColor;
}


@end
