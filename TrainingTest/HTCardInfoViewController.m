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

static NSString *SpinnerViewControllerIdentifier = @"HTSpinnerViewController";

@interface HTCardInfoViewController () <HTPaymentManagerProtocol>

@property (nonatomic) htTransationType transationType;
@property (nonatomic, strong) HTPaymentManager *paymentManager;

@property (strong, nonatomic) HTCardInfo *cardInfo;
@property (weak, nonatomic) IBOutlet UIButton *keyedTransactionButton;
@property (weak, nonatomic) IBOutlet UIImageView *cardmageView;

@end

@implementation HTCardInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.paymentManager.transationType = htTransacionTypeEMV;
    [self.paymentManager startTransaction];
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

- (IBAction)keyedTransactionPressed:(UIButton *)sender
{
    [self.paymentManager startTransaction];
}

- (void)paymentManagerdidCompleteTransaction:(HTPaymentManager *)manager
{
    // show succes screen and initiate a new segue
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

#warning HTViewController category
- (void)showSpinner
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HTSpinnerViewController *spinnerViewController = [storyboard instantiateViewControllerWithIdentifier:SpinnerViewControllerIdentifier];
    spinnerViewController.definesPresentationContext = YES;
    spinnerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    spinnerViewController.spinnerImageView.image = [UIImage imageNamed:@"spinner"];
    [self presentViewController:spinnerViewController animated:YES completion:^{
        [spinnerViewController rotate];
    }];
}

#pragma mark - Navigation

 - (IBAction)unwindToCardInfo:(UIStoryboardSegue *)unwindSegue
 {
     
 }

@end
