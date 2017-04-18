//
//  HTCardInfoViewController.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/5/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTCardInfoViewController.h"

@interface HTCardInfoViewController ()

@end

@implementation HTCardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)payPressed:(UIButton *)sender
{
    if (YES)
    {
        [self performSegueWithIdentifier:@"Accept" sender:sender];
    }
    else
    {
        [self performSegueWithIdentifier:@"Decline" sender:sender];
    }
}

- (IBAction)unwindToCardInfo:(UIStoryboardSegue *)unwindSegue
{
    
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
