//
//  WebProvider.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 17/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTWebProvider.h"
#import "HTEmailReceipt.h"
#import "HTWebProvider+Settings.h"


#define gatewayEndpoint @"https://stagegw.transnox.com/servlets/TransNox_API_Server"

@interface HTWebProvider ()

@end

@implementation HTWebProvider

+ (id)sharedProvider
{
    static HTWebProvider *sharedProvider = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedProvider = [[self alloc] init];
    });
    return sharedProvider;
}

- (void)createNewTicketWithBody:(NSDictionary *)body
{
    //[self postRequestWithBody:body];
}

- (void)paymentRequestWithData:(NSDictionary *)paymentData completion:(completionHandler)completionBlock
{
    NSMutableURLRequest *transactionRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:gatewayEndpoint]];
    [transactionRequest setAllHTTPHeaderFields:@{@"User-Agent" : @"Infonox"}];
    NSData *requestJSON = [NSJSONSerialization dataWithJSONObject:paymentData options:0 error:nil];
    [transactionRequest setHTTPBody:requestJSON];
    [transactionRequest setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *transaction = [session dataTaskWithRequest:transactionRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error)
        {
            completionBlock(data);
        }
    }];
    [transaction resume];
}

- (void)postRequestWithBody:(NSData *)body completionHandler:(completionHandler)completionBlock
{
    // endpoint string
    NSString *host = @"https://lighthouse-api-staging.harbortouch.com";
    NSString *urlString = [host stringByAppendingString:@"/oauth2/token/"];
    // session
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *postTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error)
        {
            completionBlock(data);
        }
    }];
    [postTask resume];
}

- (void)refreshToken:(NSDictionary *)body completionHandler:(completionHandler)completionBlock
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    [self postRequestWithBody:data completionHandler:^(NSData *data) {
        completionBlock(data);
    }];
}

- (void)GETRequestToEndpoint:(NSString *)endpoint body:(NSData *)body withToken:(NSString *)token completionHandler:(completionHandler)completionBlock
{
    NSString *urlString = [@"https://lighthouse-api-staging.harbortouch.com" stringByAppendingString:endpoint];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:body];
    [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask *getTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error)
        {
            completionBlock(data);
        }
    }];
    [getTask resume];
}

- (void)POSTRequestToEndpoint:(NSString *)endpoint body:(NSDictionary *)body withToken:(NSString *)token completionHandler:(completionHandler)completionBlock
{
    NSData *data= [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    NSString *urlString = [@"https://lighthouse-api-staging.harbortouch.com" stringByAppendingString:endpoint];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    [request setHTTPMethod:@"POST"];
    NSURLSessionDataTask *postTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error)
        {
            completionBlock(data);
        }
    }];
    [postTask resume];
}

- (void)sendEmail:(HTEmailReceipt *)email
{
    NSDictionary *data = [email deserialize];
    [self POSTRequestToEndpoint:@"/api/v1/notifications/email" body:data withToken:self.token completionHandler:^(NSData *data) {
        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
    }];
}

@end
