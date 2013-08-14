//
//  UIBarButtonItem+Extension.h
//  MyDouban
//
//  Created by Leon on 13-8-14.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ExtendBarButtonItemStyleBlue = 100,
} ExtendBarButtonItemStyle;

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title style:(ExtendBarButtonItemStyle)style target:(id)target action:(SEL)action;

@end
