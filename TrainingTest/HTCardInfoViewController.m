//
//  HTCardInfoViewController.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/5/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTCardInfoViewController.h"
#import <IDTech/IDTech.h>
#import "HTCardInfo.h"

@interface HTCardInfoViewController () <IDT_UniPayIII_Delegate>

@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardHolder;
@property (weak, nonatomic) IBOutlet UITextField *expDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;
@property (weak, nonatomic) IBOutlet UITextField *cvvTextField;

// demonstrative-testing purposes
@property (weak, nonatomic) IBOutlet UILabel *readerStatusLabel;


@property (strong, nonatomic) HTCardInfo *cardInfo;

@end

@implementation HTCardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[IDT_UniPayIII sharedController] setDelegate:self];
    
    // ui setup
    self.readerStatusLabel.hidden = YES;
    [self.expDateTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"MM/YY" attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor]}]];
    [self.cardHolder setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Name on Card" attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor]}]];
    [self.zipTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Zip" attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor]}]];
    [self.cvvTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"CVV" attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor]}]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)payPressed:(UIButton *)sender
{
    if ((YES))
    {
        [self performSegueWithIdentifier:@"Accept" sender:sender];
    }
    else
    {
        [self performSegueWithIdentifier:@"Decline" sender:sender];
    }
}

-(HTCardInfo *)cardInfo
{
    if (!_cardInfo)
    {
        _cardInfo = [[HTCardInfo alloc] init];
    }
    return _cardInfo;
}


#pragma mark UniPay delegate methods

-(void)deviceConnected
{
   self.readerStatusLabel.hidden = NO;
    [self startMSR_CTLS];
}
-(void) deviceDisconnected
{
    self.readerStatusLabel.hidden = YES;
}

- (void) plugStatusChange:(BOOL)deviceInserted
{
    if (deviceInserted)
    {
        [[IDT_UniPayIII sharedController] device_connectToAudioReader];
        
    }
    else
    {
       // device removed
    }
}

-(void)startMSR_CTLS
{
    RETURN_CODE rt = [[IDT_UniPayIII sharedController] ctls_startTransaction];
    if(RETURN_CODE_DO_SUCCESS == rt)
    {
        NSLog(@"EnableMSR/CTLS: OK.");
    }
}

- (void)swipeMSRData:(IDTMSRData*)cardData{
    NSLog(@"--MSR event Received, Type: %d, data: %@", cardData.event, cardData.encTrack1);
    [self parseTrack1:cardData.track1];
    switch (cardData.event) {
        case EVENT_MSR_CARD_DATA:
        {
            switch (cardData.captureEncodeType) {
                case CAPTURE_ENCODE_TYPE_ISOABA:
                    //[self appendMessageToResults:[NSString stringWithFormat:@"Encode Type: %@", @"ISO/ABA"]];
                    break;
                case CAPTURE_ENCODE_TYPE_AAMVA:
                    //[self appendMessageToResults:[NSString stringWithFormat:@"Encode Type: %@", @"AA/MVA"]];
                    break;
                    
                case CAPTURE_ENCODE_TYPE_Other:
                    //[self appendMessageToResults:[NSString stringWithFormat:@"Encode Type: %@", @"Other"]];
                    break;
                    
                case CAPTURE_ENCODE_TYPE_Raw:
                    //[self appendMessageToResults:[NSString stringWithFormat:@"Encode Type: %@", @"Raw"]];
                    break;
                    
                case CAPTURE_ENCODE_TYPE_JIS_I:
                    //[self appendMessageToResults:[NSString stringWithFormat:@"Encode Type: %@", @"CAPTURE_ENCODE_TYPE_JIS_I"]];
                    break;
                    
                case CAPTURE_ENCODE_TYPE_JIS_II:
                    //[self appendMessageToResults:[NSString stringWithFormat:@"Encode Type: %@", @"CAPTURE_ENCODE_TYPE_JIS_II"]];
                    break;
                    
                default:
                    //[self appendMessageToResults:[NSString stringWithFormat:@"Encode Type: %@", @"UNKNOWN"]];
                    
                    break;
            }
            
//            switch (cardData.captureEncryptType)
//            {
//                case CAPTURE_ENCRYPT_TYPE_AES:
//                    [self appendMessageToResults:[NSString stringWithFormat:@"Encrypt Type: %@", @"AES"]];
//                    break;
//                case CAPTURE_ENCRYPT_TYPE_TDES:
//                    [self appendMessageToResults:[NSString stringWithFormat:@"Encrypt Type: %@", @"TDES"]];
//                    break;
//                case CAPTURE_ENCRYPT_TYPE_NO_ENCRYPTION:
//                    [self appendMessageToResults:[NSString stringWithFormat:@"Encrypt Type: %@", @"NONE"]];
//                    break;
//                    
//                    
//                default:
//                    [self appendMessageToResults:[NSString stringWithFormat:@"Encrypt Type: %@", @"UNKNOWN"]];
//                    
//                    break;
//            }
//            
//            [self appendMessageToResults:[NSString stringWithFormat:@"Full card data: %@", cardData.cardData]];
//            [self appendMessageToResults:[NSString stringWithFormat:@"Track 1: %@", cardData.track1]];
//            [self appendMessageToResults:[NSString stringWithFormat:@"Track 2: %@", cardData.track2]];
//            [self appendMessageToResults:[NSString stringWithFormat:@"Track 3: %@", cardData.track3]];
//            [self appendMessageToResults:[NSString stringWithFormat:@"Length Track 1: %i", cardData.track1Length]];
//            [self appendMessageToResults:[NSString stringWithFormat:@"Length Track 2: %i", cardData.track2Length]];
//            [self appendMessageToResults:[NSString stringWithFormat:@"Length Track 3: %i", cardData.track3Length]];
//            [self appendMessageToResults:[NSString stringWithFormat:@"Encoded Track 1: %@", cardData.encTrack1.description]];
//            [self appendMessageToResults:[NSString stringWithFormat:@"Encoded Track 2: %@", cardData.encTrack2.description]];
//            [self appendMessageToResults:[NSString stringWithFormat:@"Encoded Track 3: %@", cardData.encTrack3.description]];
//            [self appendMessageToResults:[NSString stringWithFormat:@"Hash Track 1: %@", cardData.hashTrack1.description]];
//            [self appendMessageToResults:[NSString stringWithFormat:@"Hash Track 2: %@", cardData.hashTrack2.description]];
//            [self appendMessageToResults:[NSString stringWithFormat:@"Hash Track 3: %@", cardData.hashTrack3.description]];
//            [self appendMessageToResults:[NSString stringWithFormat:@"KSN: %@", cardData.KSN.description]];
//            [self appendMessageToResults:[NSString stringWithFormat:@"\nSessionID: %@",  cardData.sessionID.description]];
//            [self appendMessageToResults:[NSString stringWithFormat:@"\nReader Serial Number: %@",  cardData.RSN]];
//            [self appendMessageToResults:[NSString stringWithFormat:@"\nRead Status: %2X",  cardData.readStatus]];
//            if (cardData.unencryptedTags != nil) [self appendMessageToResults:[NSString stringWithFormat:@"Unencrytped Tags: %@", cardData.unencryptedTags.description]];
//            if (cardData.encryptedTags != nil) [self appendMessageToResults:[NSString stringWithFormat:@"Encrypted Tags: %@", cardData.encryptedTags.description]];
//            if (cardData.maskedTags != nil) [self appendMessageToResults:[NSString stringWithFormat:@"Masked Tags: %@", cardData.maskedTags.description]];
            
            NSLog(@"Track 1: %@", cardData.track1);
            NSLog(@"Track 2: %@", cardData.track2);
            NSLog(@"Track 3: %@", cardData.track3);
            NSLog(@"Encoded Track 1: %@", cardData.encTrack1.description);
            NSLog(@"Encoded Track 2: %@", cardData.encTrack2.description);
            NSLog(@"Encoded Track 3: %@", cardData.encTrack3.description);
            NSLog(@"Hash Track 1: %@", cardData.hashTrack1.description);
            NSLog(@"Hash Track 2: %@", cardData.hashTrack2.description);
            NSLog(@"Hash Track 3: %@", cardData.hashTrack3.description);
            NSLog(@"SessionID: %@", cardData.sessionID.description);
            NSLog(@"nReader Serial Number: %@", cardData.RSN);
            NSLog(@"Read Status: %2X", cardData.readStatus);
            NSLog(@"KSN: %@", cardData.KSN.description);
            
            return;
        }
            break;
            
        case EVENT_MSR_CANCEL_KEY:
        {
            [self appendMessageToResults:[NSString stringWithFormat:@"(Event) MSR Cancel Key received: %@", cardData.encTrack1]];
            return;
        }
            break;
            
        case EVENT_MSR_BACKSPACE_KEY:
        {
            [self appendMessageToResults:[NSString stringWithFormat:@"(Event) MSR Backspace Key received: %@", cardData.encTrack1]];
            return;
        }
            break;
            
        case EVENT_MSR_ENTER_KEY:
        {
            [self appendMessageToResults:[NSString stringWithFormat:@"(Event) MSR Enter Key received: %@", cardData.encTrack1]];
            return;
        }
            break;
            
        case EVENT_MSR_UNKNOWN:
        {
            [self appendMessageToResults:[NSString stringWithFormat:@"(Event) MSR unknown event, data: %@", cardData.encTrack1]];
            return;
        }
            break;
        case EVENT_MSR_TIMEOUT:
        {
            [self appendMessageToResults:@"(Event) MSR TIMEOUT"];
            return;
        }
        default:
            break;
    }
}

- (void)parseTrack1:(NSString *)track
{
    NSRegularExpression *testExpression = [NSRegularExpression regularExpressionWithPattern:@"\\d{2,}|[a-zA-Z]{2,}"
                                                                                    options:NSRegularExpressionCaseInsensitive
                                                                                      error:nil];
    NSArray *matches = [testExpression matchesInString:track
                                               options:0
                                                 range:NSMakeRange(0, [track length])];
    NSMutableArray *components = [NSMutableArray array];
    [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL *stop) {
        for (int i = 0; i < [obj numberOfRanges]; i++)
        {
            NSRange range = [obj rangeAtIndex:i];
            NSString *string = [track substringWithRange:range];
            [components addObject: string];
        }
    }];
    self.cardInfo.firstName = components[1];
    self.cardInfo.lastName = components[2];
    self.cardInfo.cardNumber = components[0];
    self.cardInfo.expDate = [components lastObject];
    self.cardNumberTextField.text = self.cardInfo.cardNumber;
    self.cardHolder.text = [NSString stringWithFormat:@"%@/%@", self.cardInfo.firstName, self.cardInfo.lastName];
    self.expDateTextField.text = [self.cardInfo.expDate substringWithRange:NSMakeRange(0, 4)];
}



- (void)emvTransactionData:(IDTEMVData*)emvData errorCode:(int)error{
    NSLog(@"EMV_RESULT_CODE_V2_response = %2X",error);
    
    [self appendMessageToResults:[NSString stringWithFormat:@"EMV_RESULT_CODE_V2_response = %2X",error]];
    if (emvData == nil) {
        [self appendMessageToResults:[NSString stringWithFormat:@"EMV TRANSACTION ERROR. Refer to EMV_RESULT_CODE_V2_response = 0x%2X",error]];
        return;
    }
    
    if (emvData.resultCodeV2 == EMV_RESULT_CODE_V2_GO_ONLINE) {
        [self appendMessageToResults:@"ONLINE REQUEST"];
    }
    if (emvData.resultCodeV2 == EMV_RESULT_CODE_V2_APPROVED || emvData.resultCodeV2 == EMV_RESULT_CODE_V2_APPROVED_OFFLINE ) {
        [self appendMessageToResults:@"APPROVED"];
    }
    if (emvData.resultCodeV2 == EMV_RESULT_CODE_V2_MSR_SUCCESS) {
        [self appendMessageToResults:@"MSR Data Captured"];
    }
    
    if (emvData.cardType == 0) {
        [self appendMessageToResults:@"CONTACT"];
    }
    if (emvData.cardType == 1) {
        [self appendMessageToResults:@"CONTACTLESS"];
    }
    
    if (emvData.unencryptedTags != nil) [self appendMessageToResults:[NSString stringWithFormat:@"Unencrytped Tags: %@", emvData.unencryptedTags.description]];
    if (emvData.encryptedTags != nil) [self appendMessageToResults:[NSString stringWithFormat:@"Encrypted Tags: %@", emvData.encryptedTags.description]];
    if (emvData.maskedTags != nil) [self appendMessageToResults:[NSString stringWithFormat:@"Masked Tags: %@", emvData.maskedTags.description]];
    if (emvData.cardData != nil) [self swipeMSRData:emvData.cardData];
}

-(void)getFirmware
{
    NSString *result;
    //logTextView.text = @"";
    RETURN_CODE rt = [[IDT_UniPayIII sharedController]  device_getFirmwareVersion:&result];
    if (RETURN_CODE_DO_SUCCESS == rt)
    {
        result = [NSString stringWithFormat:@"Get FM info:  %@", result];
    }
}

-(void) appendMessageToResults:(NSString*) message
{
    // todo
}

#pragma mark - Navigation

 - (IBAction)unwindToCardInfo:(UIStoryboardSegue *)unwindSegue
 {
 
 }

@end
