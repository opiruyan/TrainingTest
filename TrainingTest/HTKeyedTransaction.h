//
//  HTKeyedTransaction.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 31/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTTransaction.h"
#import "HTCardInfo.h"

@interface HTKeyedTransaction : HTTransaction

- (instancetype)initWithCardData:(HTCardInfo *)cardData;

@end
