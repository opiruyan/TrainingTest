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
#import "HTSpinnerViewController.h"
#import "UIView+Animation.h"
#import "UIViewController+Spinner.h"
#import "UIViewController+Back.h"
#import "HTSignatureViewController.h"

@interface HTCardInfoViewController () <HTPaymentManagerProtocol>

@property (nonatomic, strong) HTPaymentManager *paymentManager;

@property (strong, nonatomic) HTCardInfo *cardInfo;
@property (weak, nonatomic) IBOutlet UIButton *keyedTransactionButton;
@property (weak, nonatomic) IBOutlet UIImageView *cardmageView;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UILabel *buttonInstructionLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *readerImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardCenterToReaderConstraint;

@end

@implementation HTCardInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.paymentManager.emvTransationType = YES;
    [self.paymentManager startTransaction];
    [self setCustomBackWithTarget:self];
    self.amountLabel.text = [NSString stringWithFormat:@"$%.02f", [[HTPayment currentPayment] amount].floatValue];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.cardmageView animateInsert];
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

#pragma mark - Payment Manager Delegate

- (void)paymentManager:(HTPaymentManager *)manager didRecieveCardData:(HTCardInfo *)cardInfo
{
    [self showSpinner];
}

- (IBAction)transactionTypePressed:(UIButton *)sender
{
    [self.cardmageView.layer removeAllAnimations];
    self.paymentManager.emvTransationType = !self.paymentManager.emvTransationType;
    if (self.paymentManager.emvTransationType)
    {
        self.instructionLabel.text = @"Insert a card";
        self.buttonInstructionLabel.text = @"Swipe Card";
        [self.readerImageView animateZoomIn];
        [self.cardmageView animateInsert];
        self.cardCenterToReaderConstraint.constant = -25;
    }
    else
    {
        self.instructionLabel.text = @"Swipe a card";
        self.buttonInstructionLabel.text = @"Insert Card";
        [self.readerImageView animateZoomOut];
        [self.cardmageView animateSwipe];
        self.cardCenterToReaderConstraint.constant = - 115;
    }
    [self.paymentManager startTransaction];
}

- (void)paymentManagerdidCompleteTransaction:(BOOL)result
{
    [self hideSpinnerToContinue:result];
//    if (result)
//    {
//        [self completeTransaction];
//    }
}

- (void)devicePlugged:(BOOL)status
{
    if (status)
    {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        //[self showSpinner];
    }
}

#pragma mark - Navigation

 - (IBAction)unwindToCardInfo:(UIStoryboardSegue *)unwindSegue
 {
     
 }

- (IBAction)keyedTransactionPressed:(UIButton *)sender
{
    [self.paymentManager stopTransaction];
}

#pragma mark wireframe methods

- (void)completeTransaction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HTSignatureViewController *signatureViewController = [storyboard instantiateViewControllerWithIdentifier:@"HTSignatureViewController"];
    [self presentViewController:signatureViewController animated:YES completion:nil];
}

@end
