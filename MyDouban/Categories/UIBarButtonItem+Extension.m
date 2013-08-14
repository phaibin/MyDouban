//
//  UIBarButtonItem+Extension.m
//  MyDouban
//
//  Created by Leon on 13-8-14.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title style:(ExtendBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    switch (style) {
        case ExtendBarButtonItemStyleBlue: {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 50, 30)];
            [button setTitle:title forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.titleLabel.shadowColor = [UIColor blackColor];
            button.titleLabel.shadowOffset = CGSizeMake(0, -1);
            [button setBackgroundImage:[[UIImage imageNamed:@"icon_button_done.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 3, 10, 3)] forState:UIControlStateNormal];
            [button setBackgroundImage:[[UIImage imageNamed:@"icon_button_done_selected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 3, 10, 3)] forState:UIControlStateHighlighted];
            [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            return [[UIBarButtonItem alloc] initWithCustomView:button];
            break;
        }
        default:
            break;
    }
    return nil;
}

@end
