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

@interface SearchViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, BookCellDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)wantToReadTapped:(id)sender;
- (IBAction)readingTapped:(id)sender;
- (IBAction)hasReadTapped:(id)sender;

@end
