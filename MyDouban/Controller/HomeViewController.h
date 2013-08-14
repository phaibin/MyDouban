//
//  HomeViewController.h
//  MyDouban
//
//  Created by Leon on 13-8-9.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookCell.h"
#import "MovieCell.h"

@interface HomeViewController : UITableViewController<UISearchBarDelegate, BookCellDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end
