//
//  HTCloseTicketViewController.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/12/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTCloseTicketViewController.h"
#import "HTEmailReceipt.h"
#import "HTWebProvider.h"

@interface HTCloseTicketViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation HTCloseTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)emailReceiptPressed:(UIButton *)sender
{
    HTEmailReceipt *email = [HTEmailReceipt new];
    email.from = @"notifications@harbortouch.com";
    email.to = self.emailTextField.text;
    email.subject = @"Receipt";
    email.text = @"your email has been sent";
    [[HTWebProvider sharedProvider] sendEmail:email];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
