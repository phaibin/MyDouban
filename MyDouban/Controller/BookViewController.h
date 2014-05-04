//
//  BookViewController.h
//  MyDouban
//
//  Created by Leon on 13-8-1.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookCell.h"

@interface BookViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, BookCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSegment;

- (IBAction)showModeChanged:(id)sender;
- (IBAction)wantToReadTapped:(id)sender;
- (IBAction)readingTapped:(id)sender;
- (IBAction)hasReadTapped:(id)sender;

@end
