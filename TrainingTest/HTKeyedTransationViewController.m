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


@end

@implementation HTKeyedTransationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.paymentManager.transationType = htTransacionTypeManual; // no sense
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)payPressed:(UIButton *)sender
{
    [self showSpinner];
    [self.paymentManager  processTransactionWithCompletion:^(NSDictionary *response) {
        NSDictionary *saleResponse = [response objectForKey:@"SaleResponse"];
        //NSString *status = [[responseData objectForKey:@"SaleResponse"] objectForKey:@"FAIL"];
        if ([[saleResponse objectForKey:@"responseCode"] isEqualToString:@"A0000"])
        {
            // store payment to backend
            [[HTPayment currentPayment] storeTicket:saleResponse];
            [self hideSpinner];
            [self showComplete];
        };
    }];
}

@end
