//
//  IDTechCardReaderManager.h
//  TrainingTest
//
//  Created by Oleg Piruyan on 10/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IDTech/IDTech.h>

@class IDTEMVData, IDTechCardReaderManager;

@protocol CardReaderDelegate <NSObject>

@required

- (void)gotEMVData:(IDTEMVData *)emvData;
- (void)readerManager:(IDTechCardReaderManager *)manager detectedDevicePlugged:(BOOL)status;

@optional

- (void)didReadMSRData:(IDTMSRData *)cardData;
- (void)readerManager:(IDTechCardReaderManager *)manager didInitiateTransaction:(BOOL)success;

@end

@interface IDTechCardReaderManager : NSObject <IDT_UniPayIII_Delegate>

@property (nonatomic, weak) id <CardReaderDelegate> readerDelegate;

+ (id)sharedManager;

- (void)startEmvTransactionWithAmount:(NSDecimalNumber *)amount;
- (void)startMSRTransaction;
- (void)completeEMV;
- (void)cancelMSR;
- (void)stopTransaction;

@end
