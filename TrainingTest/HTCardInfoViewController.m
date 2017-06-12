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
#import "HTSpinnerViewController.h"
#import "UIView+Animation.h"
#import "UIViewController+Spinner.h"
#import "UIViewController+Back.h"
#import "HTSignatureViewController.h"

@interface HTCardInfoViewController () <HTPaymentManagerProtocol>

@property (nonatomic) BOOL emvTransationType;
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
    self.emvTransationType = YES;
    [self.paymentManager startTransaction];
    [self setCustomBackWithTarget:self];
    self.amountLabel.text = [NSString stringWithFormat:@"$%.02f", [[HTPayment currentPayment] amount].floatValue];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    self.emvTransationType = !self.emvTransationType;
    if (self.emvTransationType)
    {
        self.instructionLabel.text = @"Insert a card";
        self.buttonInstructionLabel.text = @"Swipe Card";
        [self.readerImageView animateZoomIn];
        self.paymentManager.transationType = htTransacionTypeEMV;
        //[self.cardmageView animateInsert];
        self.cardCenterToReaderConstraint.constant = -25;
    }
    else
    {
        self.instructionLabel.text = @"Swipe a card";
        self.buttonInstructionLabel.text = @"Insert Card";
        self.paymentManager.transationType = htTransacionTypeMSR;
        [self.readerImageView animateZoomOut];
        [self.cardmageView animateSwipe];
        self.cardCenterToReaderConstraint.constant = - 115;
    }
    [self.paymentManager stopTransaction];
    [self.paymentManager startTransaction];
}

- (void)paymentManagerdidCompleteTransaction:(BOOL)result
{
    [self hideSpinner];
    if (result)
    {
        [self completeTransaction];
    }
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

#pragma mark wireframe methods

- (void)completeTransaction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HTSignatureViewController *signatureViewController = [storyboard instantiateViewControllerWithIdentifier:@"HTSignatureViewController"];
    [self presentViewController:signatureViewController animated:YES completion:nil];
}

@end
