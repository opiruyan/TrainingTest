//
//  HTTSYSManager.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 05/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTWebProvider.h"


@interface HTTSYSManager : NSObject

- (void)performSaleRequestWithData:(NSDictionary *)emvData completion:(completionHandler)completion;
- (void)performVoidRequest;

@end
