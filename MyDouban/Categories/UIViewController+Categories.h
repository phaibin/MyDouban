//
//  UIViewController+Categories.h
//  MyDouban
//
//  Created by Leon on 5/4/14.
//  Copyright (c) 2014 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Categories)

- (void)showLoading;
- (void)showLoadingWithStatus:(NSString *)status;
- (void)showSuccessWithStatus:(NSString *)status;
- (void)showErrorWithStatus:(NSString *)status;
- (void)dismissLoading;

@end
