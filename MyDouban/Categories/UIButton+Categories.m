//
//  UIButton+Categories.m
//  Smaug
//
//  Created by Leon on 3/25/14.
//  Copyright (c) 2014 Leon. All rights reserved.
//

#import "UIButton+Categories.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIButton (Categories)

+ (UIButton *)buttonWithTitle:(NSString *)title positionY:(float)y
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, y, 290, 40);
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:kButtonBackgroundColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
//    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    return button;
}

@end
