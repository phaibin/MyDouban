//
//  LoginViewController.h
//  MyDouban
//
//  Created by Leon on 13-7-31.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : BaseViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end
