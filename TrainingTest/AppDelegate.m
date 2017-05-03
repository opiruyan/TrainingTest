//
//  AppDelegate.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 3/30/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "AppDelegate.h"
#import "HTLoginScreenViewController.h"

@interface AppDelegate ()

@property (nonatomic ,weak) id<AppURLOpenDelegate> delegate;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor darkGrayColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
        NSForegroundColorAttributeName : [UIColor whiteColor]
    }];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    // title
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    return YES;
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSRange range = [url.absoluteString rangeOfString:@"="];
    self.delegate = self;
    [self.delegate appDelegateDidHandleOpenUrl:[url.absoluteString substringFromIndex:range.location+range.length]];
    return YES;
}

- (void)appDelegateDidHandleOpenUrl:(NSString *)url
{
    NSString *host = @"https://lighthouse-api-staging.harbortouch.com";
    // retrieve app url
    NSArray *urlTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    NSArray *urlSchemes = [NSArray new];
    for (NSDictionary *dict in urlTypes)
    {
        if ([dict objectForKey:@"CFBundleURLSchemes"] )
        {
            urlSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
        }
    }
    NSString *urlString = [host stringByAppendingString:@"/oauth2/token/"];
    NSURLSession *session = [NSURLSession sharedSession];  //use NSURLSession class
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *parametera = [NSString stringWithFormat:@"grant_type=authorization_code&client_secret=cdfd0af6-38a0-4277-8d80-400055ae766e&code=%@&client_id=1688719b-f2a6-47c4-b727-bee9aeee90b1&redirect_uri=harborpay://", url];
    NSData *data = [parametera dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSURLSessionDataTask *postTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *result= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", response);
    }];
    [postTask resume];
//    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//        NSLog(@"pause");
//    }];
//    [task resume];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
