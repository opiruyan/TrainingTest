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
#import "HTKeyboardInputView.h"
#import "HTPayment.h"
#import "HTSMSReceipt.h"

#define kOFFSET_FOR_KEYBOARD 80.0

@interface HTCloseTicketViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet HTKeyboardInputView *inputView;

@end

@implementation HTCloseTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    self.inputView.translatesAutoresizingMaskIntoConstraints = YES;
    self.inputView.frame = CGRectMake(0, self.inputView.superview.frame.size.height, self.inputView.frame.size.width, self.inputView.frame.size.height);
    self.inputView.email.clearsOnBeginEditing = YES;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    // I'll try to make my text field 20 pixels above the top of the keyboard
    // To do this first we need to find out where the keyboard will be.
    
    NSValue *keyboardEndFrameValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = [keyboardEndFrameValue CGRectValue];
    
    // When we move the textField up, we want to match the animation duration and curve that
    // the keyboard displays. So we get those values out now
    
    NSNumber *animationDurationNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = [animationDurationNumber doubleValue];
    
    NSNumber *animationCurveNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = [animationCurveNumber intValue];
    
    // UIView's block-based animation methods anticipate not a UIVieAnimationCurve but a UIViewAnimationOptions.
    // We shift it according to the docs to get this curve.
    
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    
    // Now we set up our animation block.
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationOptions
                     animations:^{
                         // Now we just animate the text field up an amount according to the keyboard's height,
                         // as we mentioned above.
                         CGRect textFieldFrame = self.inputView.frame;
                         textFieldFrame.origin.y = keyboardEndFrame.origin.y - textFieldFrame.size.height - self.inputView.superview.frame.origin.y; //I don't think the keyboard takes into account the status bar
                         textFieldFrame.size.width = self.inputView.superview.frame.size.width;
                         self.inputView.frame = textFieldFrame;
                         // greay out everythin on top of input view
                         
                         UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textFieldFrame.size.width, keyboardEndFrame.origin.y - textFieldFrame.size.height)];
                         grayView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
                         [self.view addSubview:grayView];
                     }
                     completion:^(BOOL finished) {}];
}
- (IBAction)sendReceiptPressed:(id)sender
{
    self.inputView.hidden = NO;
    [self.inputView.email becomeFirstResponder];
}

- (IBAction)textReceiptPressed:(UIButton *)sender
{
    self.inputView.hidden = NO;
    [self.inputView.iconButton setImage:[UIImage imageNamed:@"chatIcon"] forState:UIControlStateNormal];
    [self.inputView.email becomeFirstResponder];
}

- (IBAction)emailReceiptPressed:(UIButton *)sender
{
//    HTEmailReceipt *email = [HTEmailReceipt new];
//    email.from = @"notifications@harbortouch.com";
//    email.to = self.inputView.email.text;
//    email.subject = @"Receipt";
//    email.text = @"your email has been sent";
//    [[HTWebProvider sharedProvider] sendEmail:email];
    HTSMSReceipt *sms = [HTSMSReceipt new];
    sms.to = self.inputView.email.text;
    sms.text = @"your email has been sent";
    [[HTWebProvider sharedProvider] sendSms:sms];
    self.inputView.hidden = YES;
    [self.view.subviews.lastObject removeFromSuperview];
    [self.view endEditing:YES];
    
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
