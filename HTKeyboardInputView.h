//
//  HTKeyboardInputView.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 09/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTKeyboardInputView : UIView

@property (nonatomic ,weak) IBOutlet UITextField *email;
@property (nonatomic ,weak) IBOutlet NSLayoutConstraint *heightContraint;

@end
