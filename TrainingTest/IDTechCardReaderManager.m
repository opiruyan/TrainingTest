//
//  IDTechCardReaderManager.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 10/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "IDTechCardReaderManager.h"
#import "HTCardInfo.h"


@interface IDTechCardReaderManager ()

@property (nonatomic) BOOL cardReaderConnected;

@end

@implementation IDTechCardReaderManager

#pragma mark UniPay delegate methods

-(void)deviceConnected
{
    [self.readerDelegate readerManager:self detectedDevicePlugged:YES];
}

-(void)deviceDisconnected
{
   [self.readerDelegate readerManager:self detectedDevicePlugged:NO];
}

- (void)plugStatusChange:(BOOL)deviceInserted
{
    if (deviceInserted)
    {
        [[IDT_UniPayIII sharedController] device_connectToAudioReader];
    }
    else
    {
        self.cardReaderConnected = NO;
        // device removed
    }
}

-(void)startMSRTransaction
{
    RETURN_CODE rt = [[IDT_UniPayIII sharedController] ctls_startTransaction];
    if(RETURN_CODE_DO_SUCCESS == rt)
    {
        NSLog(@"EnableMSR/CTLS: OK.");
    }
}

- (void)emvTransactionData:(IDTEMVData*)emvData errorCode:(int)error{
    NSLog(@"EMV_RESULT_CODE_V2_response = %2X",error);
    
    
    if (emvData == nil)
    {
        return;
    }
    
    if (emvData.resultCodeV2 == EMV_RESULT_CODE_V2_GO_ONLINE)
    {
        
    }
    if (emvData.resultCodeV2 == EMV_RESULT_CODE_V2_APPROVED || emvData.resultCodeV2 == EMV_RESULT_CODE_V2_APPROVED_OFFLINE )
    {
        
    }
    if (emvData.resultCodeV2 == EMV_RESULT_CODE_V2_MSR_SUCCESS) {
        
    }

    
    if (emvData.cardData != nil)
    {
        [self swipeMSRData:emvData.cardData];
    }
    else if (emvData.unencryptedTags)
    {
        [self.transactionDelegate gotEMVData:emvData];
    }
}

- (void)startEmvTransactionWithAmount:(NSDecimalNumber *)amount
{
    //[[IDT_UniPayIII sharedController] emv_retrieveTerminalData:&res];
    [[IDT_UniPayIII sharedController] emv_disableAutoAuthenticateTransaction:NO];
    RETURN_CODE rt = [[IDT_UniPayIII sharedController] emv_startTransaction:amount.floatValue amtOther:0 type:0 timeout:60 tags:nil forceOnline:false fallback:true];
    if (RETURN_CODE_DO_SUCCESS == rt)
    {
        NSLog(@"Start Transaction Command Accepted");
    }
    else
    {
        NSLog(@"Start Transaction info");
    }
}

- (void)swipeMSRData:(IDTMSRData*)cardData
{
    switch (cardData.event)
    {
        case EVENT_MSR_CARD_DATA:
            [self.transactionDelegate didReadMSRData:cardData];
            break;
        case EVENT_MSR_DATA_ERROR:
            NSLog(@"swipe once more");
        default:
            break;
    }
}

-(void)authEMV
{
    RETURN_CODE rt = [[IDT_UniPayIII sharedController] emv_authenticateTransaction:nil];
    if (RETURN_CODE_DO_SUCCESS == rt)
    {
      
    }
    else
    {
        NSLog(@"Start Transaction info");
    }
}

- (void)completeEMV
{
    RETURN_CODE rt = [[IDT_UniPayIII sharedController]  emv_completeOnlineEMVTransaction:true hostResponseTags:[IDTUtility hexToData:@"8A023030"]];
    if (RETURN_CODE_DO_SUCCESS == rt)
    {
        NSLog(@"Transaction was completed");
    }
    else
    {
        NSLog(@"Processing could not be completed");
    }
    
    
}

static int _lcdDisplayMode = 0;
- (void) lcdDisplay:(int)mode  lines:(NSArray*)lines{
    NSMutableString* str = [NSMutableString new];
    _lcdDisplayMode = mode;
    if (lines != nil) {
        for (NSString* s in lines) {
            [str appendString:s];
            [str appendString:@"\n"];
        }
    }
    
    switch (mode) {
        case 0x10:
            //clear screen
            //resultsTextView.text = @"";
            break;
        case 0x03:
            NSLog(@"%@", str);
            break;
        case 0x01:
        case 0x02:
        case 0x08:{
        }
            
            break;
        default:
            break;
    }
}

- (NSData *)hexToData:(NSString*)str {   //Example - Pass string that contains characters "30313233", and it will return a data object containing ascii characters "0123"
    if ([str length] == 0) {
        return nil;
    }
    
    unsigned stringIndex=0, resultIndex=0, max=(int)[str length];
    NSMutableData* result = [NSMutableData dataWithLength:(max + 1)/2];
    unsigned char* bytes = [result mutableBytes];
    
    unsigned num_nibbles = 0;
    unsigned char byte_value = 0;
    
    for (stringIndex = 0; stringIndex < max; stringIndex++) {
        unsigned int val = [self char2hex:[str characterAtIndex:stringIndex]];
        
        num_nibbles++;
        byte_value = byte_value * 16 + (unsigned char)val;
        if (! (num_nibbles % 2)) {
            bytes[resultIndex++] = byte_value;
            byte_value = 0;
        }
    }
    
    
    //final nibble
    if (num_nibbles % 2) {
        bytes[resultIndex++] = byte_value;
    }
    
    [result setLength:resultIndex];
    
    return result;
}

-(unsigned int) char2hex:(char)c{
    
    switch (c) {
        case '0' ... '9': return c - '0';
        case 'a' ... 'f': return c - 'a' + 10;
        case 'A' ... 'F': return c - 'A' + 10;
        default: return -1;
    }
}



@end
