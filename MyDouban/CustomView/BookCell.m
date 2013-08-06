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
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)wantReadTapped:(id)sender
{
    
}

- (IBAction)readingTapped:(id)sender
{
    
}

- (IBAction)hasReadTapped:(id)sender
{
    
}

@end
