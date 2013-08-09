//
//  MovieCell.h
//  MyDouban
//
//  Created by Leon on 13-8-6.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBMovie.h"

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (nonatomic, weak) DBMovie *movie;

@end
