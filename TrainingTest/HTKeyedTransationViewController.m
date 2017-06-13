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

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
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
    [self registerForKeyboardNotifications];
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
    cardInfo.expDate = self.yearTextField.text.length > 0 ? [self.monthTextField.text stringByAppendingString:[self.yearTextField.text substringFromIndex:2]] : nil;
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

#pragma mark - Managing Keyboard apperence

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.yearTextField.frame.origin) )
    {
        [self.scrollView scrollRectToVisible:self.yearTextField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end
