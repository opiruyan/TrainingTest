//
//  HTCardInfoViewController.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/5/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTCardInfoViewController.h"
#import "HTPaymentManager.h"
#import "HTPayment.h"
#import "HTPaymentManager+transactionTypes.h"
#import "IDTechCardReaderManager.h"

@interface HTCardInfoViewController () <CardReaderStateDelegate, HTPaymentManagerProtocol, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardHolder;
@property (weak, nonatomic) IBOutlet UITextField *expDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;
@property (weak, nonatomic) IBOutlet UITextField *cvvTextField;

// demonstrative-testing purposes
@property (weak, nonatomic) IBOutlet UILabel *readerStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIPickerView *transactionTypePicker;
@property (nonatomic) htTransationType transationType;
@property (nonatomic, strong) HTPaymentManager *paymentManager;
@property (strong, nonatomic) IDTechCardReaderManager *cardReaderManager;

@property (strong, nonatomic) HTCardInfo *cardInfo;

@end

@implementation HTCardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ui setup
    self.readerStatusLabel.hidden = YES;
    [self.expDateTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"MM/YY" attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor]}]];
    [self.cardHolder setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Name on Card" attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor]}]];
    [self.zipTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Zip" attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor]}]];
    [self.cvvTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"CVV" attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor]}]];
    self.navigationItem.title = [@"Total $" stringByAppendingString:[[[HTPayment currentPayment] amount] stringValue]];
    self.transationType = htTransacionTypeManual;
    self.transactionTypePicker.delegate = self;
     [[IDT_UniPayIII sharedController] setDelegate:self.cardReaderManager];
    
}

- (HTPaymentManager *)paymentManager
{
    if (!_paymentManager)
    {
        _paymentManager = [[HTPaymentManager alloc] init];
        _paymentManager.delegate = self;
    }
    return _paymentManager;
}

- (IDTechCardReaderManager *)cardReaderManager
{
    if (!_cardReaderManager)
    {
        _cardReaderManager = [[IDTechCardReaderManager alloc] init];
        _cardReaderManager.readerDelegate = self;
        _cardReaderManager.transactionDelegate = self.paymentManager;
    }
    return _cardReaderManager;
}

- (IBAction)payPressed:(UIButton *)sender
{
    switch ([self.transactionTypePicker selectedRowInComponent:0]) // there is only one component
    {
        case htTransacionTypeManual:
            [self startManualTransaction];
            break;
        case htTransacionTypeEMV:
            [self.paymentManager startEmvTransaction];
            break;
        case htTransacionTypeMSR:
            [self.paymentManager startMSRTransaction];
            break;
        default:
            break;
    }
//    if ((YES))
//    {
//        [self performSegueWithIdentifier:@"Accept" sender:sender];
//    }
//    else
//    {
//        [self performSegueWithIdentifier:@"Decline" sender:sender];
//    }
}

- (void)startManualTransaction
{
    [self.paymentManager startKeyedTransactionWithAmount:[[HTPayment currentPayment] amount]
                                              cardNumber:self.cardNumberTextField.text
                                          expirationDate:self.expDateTextField.text];
}

#pragma maek - Card Raeader State Delegate

- (void)devicePlugged:(BOOL)status
{
    self.readerStatusLabel.hidden = !status;
    if (status)
    {
        [self.payButton.titleLabel setText:@"Please, swipe or insert card"];    
    }
}

#pragma mark - Picker Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.paymentManager transactionTypeForNumber:row];
}

#pragma mark - Payment Datasource Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.paymentManager numberOfTransactions];
}

#pragma mark - Payment Manager Delegate

- (void)paymentManager:(HTPaymentManager *)manager didRecieveCardData:(HTCardInfo *)cardInfo
{
    self.cardNumberTextField.text = cardInfo.cardNumber;
    self.cardHolder.text = [NSString stringWithFormat:@"%@/%@",cardInfo.firstName, cardInfo.lastName];
    self.expDateTextField.text = [cardInfo.expDate substringWithRange:NSMakeRange(0, 4)];
}

#pragma mark - Navigation

 - (IBAction)unwindToCardInfo:(UIStoryboardSegue *)unwindSegue
 {
 
 }

@end
