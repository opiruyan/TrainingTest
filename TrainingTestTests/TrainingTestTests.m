//
//  TrainingTestTests.m
//  TrainingTestTests
//
//  Created by Oleg Piruyan on 3/30/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "HTKeypadViewController.h"

@interface HTKeypadViewController (testing)

@property (weak, nonatomic, readonly) IBOutlet UITextField *cardNumberTextField;

@end

@interface TrainingTestTests : XCTestCase

{
    // add instance variables to the CalcTests class
@private
    UIApplication       *app;
    HTKeypadViewController  *keypadViewController;
    UIView              *calcView;
}

@end

@implementation TrainingTestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    app = [UIApplication sharedApplication];
    keypadViewController = [[HTKeypadViewController alloc] init];
    calcView = keypadViewController.view;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSString *string = @"DEVICE CONNECTED";
    XCTAssertEqualObjects(string, keypadViewController.cardNumberTextField.text);
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


//- (void)testTyping
//{
//    keypadViewController press
//}



@end
