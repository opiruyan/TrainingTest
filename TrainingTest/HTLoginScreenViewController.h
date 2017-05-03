//
//  HTLoginScreenViewController.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/3/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppURLOpenDelegate <NSObject>

- (void)appDelegateDidHandleOpenUrl:(NSString *)url;

@end

@interface HTLoginScreenViewController : UIViewController

@end
