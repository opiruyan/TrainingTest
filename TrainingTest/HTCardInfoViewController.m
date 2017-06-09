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

@interface HTCardInfoViewController () <HTPaymentManagerProtocol>

@property (nonatomic) htTransationType transationType;
@property (nonatomic, strong) HTPaymentManager *paymentManager;

@property (strong, nonatomic) HTCardInfo *cardInfo;
@property (weak, nonatomic) IBOutlet UIButton *keyedTransactionButton;
@property (weak, nonatomic) IBOutlet UIImageView *cardmageView;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UILabel *buttonInstructionLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end

@implementation HTCardInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.paymentManager.transationType = htTransacionTypeEMV;
    [self.paymentManager startTransaction];
    [self setCustomBackWithTarget:self];
    self.amountLabel.text = [NSString stringWithFormat:@"$%.02f", [[HTPayment currentPayment] amount].floatValue];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.cardmageView animateSwipe];
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
    [self.paymentManager stopTransaction];
    self.transationType = (self.transationType + 1) % 2;
    if (self.transationType == htTransacionTypeEMV)
    {
        self.instructionLabel.text = @"Insert a card";
        self.buttonInstructionLabel.text = @"Swipe Card";
    }
    else
    {
        self.instructionLabel.text = @"Swipe a card";
        self.buttonInstructionLabel.text = @"Insert Card";
    }
    [self.paymentManager startTransaction];
}

- (void)paymentManagerdidCompleteTransaction:(HTPaymentManager *)manager
{
    [self hideSpinner];
}

- (void)devicePlugged:(BOOL)status
{
    if (status)
    {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self showSpinner];
    }
}

#pragma mark - Navigation

 - (IBAction)unwindToCardInfo:(UIStoryboardSegue *)unwindSegue
 {
     
 }

@end
