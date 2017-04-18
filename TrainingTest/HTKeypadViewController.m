//
//  HTKeypadViewController.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/4/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTKeypadViewController.h"

@interface HTKeypadButton : UIButton

@property (nonatomic, strong) NSString *number;

@end

@implementation HTKeypadButton


@end

@interface HTKeypadViewController ()

@property (weak, nonatomic) IBOutlet UITextField *TotalTextField;
@property (nonatomic, strong) NSMutableString *totalString;

@end

@implementation HTKeypadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.totalString =[NSMutableString string];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)numberPressed:(HTKeypadButton *)sender
{
    [self.totalString appendString:sender.number];
    self.TotalTextField.text = self.totalString;
}

- (IBAction)cancelPressed:(UIButton *)sender
{
    self.totalString = [NSMutableString stringWithString:@"0"];
    self.TotalTextField.text = self.totalString;
}

- (IBAction)unwindToKeypad:(UIStoryboardSegue *)unwindSegue
{
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destinationViewController = [segue destinationViewController];
    destinationViewController.navigationItem.title = [@"Total" stringByAppendingString:self.totalString];
}


@end
