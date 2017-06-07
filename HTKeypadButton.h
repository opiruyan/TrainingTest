//
//  HTKeypadButton.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 07/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface HTKeypadButton : UIButton

@property (nonatomic, strong) NSString *number;
@property (nonatomic) IBInspectable NSInteger borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat cornerRadius;


@end
