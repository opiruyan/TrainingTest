//
//  HTKeypadViewController.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/4/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTKeypadViewController.h"
#import "HTPayment.h"
#import "HTKeypadButton.h"

@interface HTButton : UIButton

@end

@implementation HTButton

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (enabled)
    {
        self.alpha = 1;
    }
    else
    {
        self.alpha = 0.4;
    }
}

@end

@interface HTKeypadViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *TotalTextField;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (nonatomic, strong) NSMutableString *totalString;

@end

@implementation HTKeypadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.totalString =[NSMutableString string];
    self.TotalTextField.delegate = self;
    [self.TotalTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"$0.00" attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor]}]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)numberPressed:(HTKeypadButton *)sender
{
    [self.totalString appendString:sender.number];
    self.TotalTextField.text = [@"$" stringByAppendingString:self.totalString];
    HTPayment *currentPayment = [HTPayment currentPayment];
    currentPayment.amount = [NSDecimalNumber decimalNumberWithString:self.totalString];
    self.payButton.enabled = [NSDecimalNumber decimalNumberWithString:self.totalString].floatValue > 0 ;
}

- (IBAction)cancelPressed:(UIButton *)sender
{
    self.totalString = [NSMutableString new];
    self.TotalTextField.text = nil;
    [self.TotalTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"$0.00" attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor]}]];
    self.payButton.enabled = NO;
}

- (IBAction)unwindToKeypad:(UIStoryboardSegue *)unwindSegue
{
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}


@end
