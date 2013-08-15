//
//  FlattenButton.m
//  MyDouban
//
//  Created by Leon on 13-8-15.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import "FlattenButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation FlattenButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self innerInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self ) {
        [self innerInit];
    }
    return self;
}

- (void)innerInit
{
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = RGBCOLOR(45, 187, 149);
    self.titleLabel.textColor = [UIColor whiteColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
