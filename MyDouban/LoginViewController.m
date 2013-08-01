//
//  LoginViewController.m
//  MyDouban
//
//  Created by Leon on 13-7-31.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import "LoginViewController.h"
#import "AFHTTPClient.h"
#import "AFAppDotNetAPIClient.h"
#import "JSONKit.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSDictionary *parameters = @{@"client_id":APP_KEY, @"redirect_uri":URL_REDIRECT, @"response_type":@"code"};
    NSURLRequest *request = [[AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@""]] requestWithMethod:@"GET" path:URL_AUTHORIZE parameters:parameters];
    [self.webview loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSLog(@"url = %@", url);
    
    NSString *errorURL = [NSString stringWithFormat:@"%@/?error=", URL_REDIRECT];
    NSString *successURL = [NSString stringWithFormat:@"%@/?code=", URL_REDIRECT];
    
    if ([url hasPrefix:errorURL]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
    } else if ([url hasPrefix:successURL]) {
        NSString *code = [url stringByReplacingOccurrencesOfString:successURL withString:@""];
        NSDictionary *parameters = @{@"client_id":APP_KEY, @"client_secret":APP_SECRET, @"redirect_uri":URL_REDIRECT, @"grant_type":@"authorization_code", @"code":code};
        [AFAppDotNetAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        [[AFAppDotNetAPIClient sharedClient] postPath:URL_TOKEN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", [responseObject JSONString]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", [error localizedDescription]);
        }];
        return NO;
    }
    
    return YES;
}

@end
