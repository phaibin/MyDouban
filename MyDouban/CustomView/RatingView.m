//
//  RatingView.m
//  MyDouban
//
//  Created by Leon on 13-8-15.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import "RatingView.h"

#define STAR_WIDTH      13
#define STAR_HEIGHT     13

@interface RatingView()

@property (nonatomic, strong) UIImageView *starImageView1;
@property (nonatomic, strong) UIImageView *starImageView2;
@property (nonatomic, strong) UIImageView *starImageView3;
@property (nonatomic, strong) UIImageView *starImageView4;
@property (nonatomic, strong) UIImageView *starImageView5;

@end

@implementation RatingView

- (void)setRating:(float)rating
{
    for (int i=0; i<5; i++) {
        UIImageView *imageView = [self valueForKey:[NSString stringWithFormat:@"starImageView%d", i+1]];
        imageView.image = [UIImage imageNamed:@"icon-star-empty.png"];
    }
    for (int i=0; i<(int)(rating/2); i++) {
        UIImageView *imageView = [self valueForKey:[NSString stringWithFormat:@"starImageView%d", i+1]];
        imageView.image = [UIImage imageNamed:@"icon-star-full.png"];
    }
    if ((int)rating != rating) {
        UIImageView *imageView = [self valueForKey:[NSString stringWithFormat:@"starImageView%d", (int)(rating/2)+1]];
        imageView.image = [UIImage imageNamed:@"icon-star-half.png"];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self innerInit];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self innerInit];
}

- (void)innerInit
{
    self.starImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-star-empty.png"]];
    [self addSubview:self.starImageView1];
    self.starImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-star-empty.png"]];
    [self addSubview:self.starImageView2];
    self.starImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-star-empty.png"]];
    [self addSubview:self.starImageView3];
    self.starImageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-star-empty.png"]];
    [self addSubview:self.starImageView4];
    self.starImageView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-star-empty.png"]];
    [self addSubview:self.starImageView5];
    for (int i=0; i<5; i++) {
        UIImageView *imageView = [self valueForKey:[NSString stringWithFormat:@"starImageView%d", i+1]];
        imageView.frame = CGRectMake(i*STAR_WIDTH, 0, STAR_WIDTH, STAR_HEIGHT);
    }
}

@end
