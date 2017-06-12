//
//  HTKeyedTransationViewController.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 08/06/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTKeyedTransationViewController.h"
#import "HTPaymentManager.h"
#import "HTKeyedTransaction.h"
#import "HTPayment.h"
#import "UIViewController+Spinner.h"
#import "UIViewController+Processing.h"

@interface HTKeyedTransationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (nonatomic ,strong) HTPaymentManager *paymentManager;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (nonatomic, strong) HTKeyedTransaction *transaction;
@property (nonatomic, strong) HTCardInfo *cardInfo;


@end

@implementation HTKeyedTransationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.paymentManager.processingTransaction = [HTKeyedTransaction new];
}

- (HTPaymentManager *)paymentManager
{
    if (!_paymentManager)
    {
        _paymentManager = [[HTPaymentManager alloc] init];
    }
    return _paymentManager;
}

- (HTKeyedTransaction *)transaction
{
    HTKeyedTransaction *transaction = [[HTKeyedTransaction alloc] initWithCardData:self.cardInfo];
    return  transaction;
}

- (HTCardInfo *)cardInfo
{
    HTCardInfo *cardInfo = [[HTCardInfo alloc] init];
    cardInfo.firstName = [[self.nameTextField.text componentsSeparatedByString:@" "] firstObject];
    cardInfo.lastName = [[self.nameTextField.text componentsSeparatedByString:@" "] lastObject];
    cardInfo.cardNumber = self.cardNumberTextField.text;
    cardInfo.expDate = [self.monthTextField.text stringByAppendingString:[self.yearTextField.text substringFromIndex:2]];
    return cardInfo;
}

- (IBAction)payPressed:(UIButton *)sender
{
    self.paymentManager.processingTransaction = self.transaction;
    [self showSpinner];
    [self.paymentManager  processTransactionWithCompletion:^(NSDictionary *response) {
        NSDictionary *saleResponse = [response objectForKey:@"SaleResponse"];
        //NSString *status = [[responseData objectForKey:@"SaleResponse"] objectForKey:@"FAIL"];
        [self hideSpinnerToContinue:[[saleResponse objectForKey:@"responseCode"] isEqualToString:@"A0000"]];
        if ([[saleResponse objectForKey:@"responseCode"] isEqualToString:@"A0000"])
        {
            // store payment to backend
            [[HTPayment currentPayment] storeTicket:saleResponse];
            //[self showComplete];
        }
        else
        {
            //[self showDeclined];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
