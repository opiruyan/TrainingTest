//
//  HTSMSReceipt.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 09/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTSMSReceipt : NSObject

@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *text;

- (NSDictionary *)deserialize;

@end
