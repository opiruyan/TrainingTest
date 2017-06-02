//
//  HTEMVTransaction.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 31/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTTransaction.h"
#import "IDTechCardReaderManager.h" // implemnts defined realization instead of protocos or superclass

@interface HTEMVTransaction : HTTransaction <CardReaderTransactionFlowDelegate>

- (instancetype)initWithDevice:(IDTechCardReaderManager *)deviceManager;

@end
