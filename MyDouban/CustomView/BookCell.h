//
//  BookCell.h
//  MyDouban
//
//  Created by Leon on 13-8-5.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBBook.h"

@interface BookCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIButton *wantReadButton;
@property (weak, nonatomic) IBOutlet UIButton *readingButton;
@property (weak, nonatomic) IBOutlet UIButton *hasReadButton;
@property (nonatomic, weak) DBBook *book;

- (IBAction)wantReadTapped:(id)sender;
- (IBAction)readingTapped:(id)sender;
- (IBAction)hasReadTapped:(id)sender;

@end
