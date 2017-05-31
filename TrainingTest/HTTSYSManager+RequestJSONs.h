//
//  HTTSYSManager+RequestJSONs.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 19/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTTSYSManager.h"

@interface HTTSYSManager (RequestJSONs)

- (NSDictionary *)requestSaleDictionaryWithEMVTags:(NSDictionary *)emvTagsDictionary;
- (NSDictionary *)dictionaryVoidRequest;

@end
