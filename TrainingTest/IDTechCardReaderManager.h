//
//  IDTechCardReaderManager.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 10/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IDTech/IDTech.h>

@class IDTEMVData;

@protocol CardReaderDelegate <NSObject>

- (void)gotEMVData:(IDTEMVData *)emvData;
- (void)didReadMSRData:(IDTMSRData *)cardData;

@end

@protocol CardReaderStateDelegate <NSObject>

- (void)devicePlugged:(BOOL)status;

@end

@interface IDTechCardReaderManager : NSObject <IDT_UniPayIII_Delegate>

@property (nonatomic, weak) id <CardReaderDelegate> transactionDelegate;
@property (nonatomic, weak) id <CardReaderStateDelegate> readerDelegate;

- (void)startEmvTransactionWithAmount:(NSDecimalNumber *)amount;
- (void)startMSRTransaction;
- (void)completeEMV;
@end
