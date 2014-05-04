//
//  BookCell.m
//  MyDouban
//
//  Created by Leon on 13-8-5.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import "BookCell.h"
#import "UIImageView+WebCache.h"

@implementation BookCell

- (void)setBook:(DBBook *)book
{
    _book = book;
    
    self.nameLabel.text = book.name;
    self.authorLabel.text = [book.authors componentsJoinedByString:@" "];
    __weak typeof(self) weakSelf = self;
    [weakSelf.coverImageView setImageWithURL:[NSURL URLWithString:book.coverImageUrl] placeholderImage:[UIImage imageNamed:@"book_default.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            weakSelf.coverImageView.image = image;
            if (cacheType == SDImageCacheTypeNone) {
                weakSelf.coverImageView.alpha = 0;
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.coverImageView.alpha = 1;
                }];
            }
        }
    }];
    self.wantReadButton.hidden = NO;
    self.readingButton.hidden = NO;
    self.hasReadButton.hidden = NO;
    if (book.status == DBBookStatusWantRead)
        self.wantReadButton.hidden = YES;
    else if (book.status == DBBookStatusReading)
        self.readingButton.hidden = YES;
    else if (book.status == DBBookStatusHasRead)
        self.hasReadButton.hidden = YES;
    
    self.hasReadButton.frame = CGRectMake(260, 60, 50, 28);
    if (self.hasReadButton.hidden) {
        self.readingButton.frame = self.hasReadButton.frame;
    } else {
        CGRect frame = self.hasReadButton.frame;
        frame.origin.x = frame.origin.x - frame.size.width - 10;
        self.readingButton.frame = frame;
    }
    if (self.readingButton.hidden) {
        self.wantReadButton.frame = self.readingButton.frame;
    } else {
        CGRect frame = self.readingButton.frame;
        frame.origin.x = frame.origin.x - frame.size.width - 10;
        self.wantReadButton.frame = frame;
    }
    
    self.ratingView.rating = book.rating;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self innerInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self innerInit];
}

- (void)innerInit
{
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectedBackgroundView.backgroundColor = RGBCOLOR(221, 233, 217);
    self.wantReadButton.tag = 0;
    self.readingButton.tag = 1;
    self.hasReadButton.tag = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
