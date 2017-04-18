//
//  HTSignatureView.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/3/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTSignatureViewDelegate <NSObject>

- (void)signatureViewDidStartEditing:(UIView *)view;

@end

@interface HTSignatureView : UIView

@property (nonatomic ,weak) id <HTSignatureViewDelegate> delegate;

@end
