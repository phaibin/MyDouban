//
//  BookCell.h
//  MyDouban
//
//  Created by Leon on 13-8-5.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBBook.h"
#import "RatingView.h"

@protocol BookCellDelegate <NSObject>

@optional

- (void)bookStatusChanged:(DBBook *)book fromStatus:(DBBookStatus)status;
- (void)bookStatusChangeFailed:(DBBook *)book withError:(NSError *)error;

@end

@interface BookCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIButton *wantReadButton;
@property (weak, nonatomic) IBOutlet UIButton *readingButton;
@property (weak, nonatomic) IBOutlet UIButton *hasReadButton;
@property (weak, nonatomic) IBOutlet RatingView *ratingView;
@property (nonatomic, weak) DBBook *book;
@property (nonatomic, weak) id<BookCellDelegate> delegate;

@end
