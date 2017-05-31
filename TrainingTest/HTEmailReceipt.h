//
//  HTEmailReceipt.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 25/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTEmailReceipt : NSObject

@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *text;

- (NSDictionary *)deserialize;

@end
