//
//  BookViewController.h
//  MyDouban
//
//  Created by Leon on 13-8-1.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookCell.h"

@interface BookViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, BookCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *wantReadTableView;
@property (weak, nonatomic) IBOutlet UITableView *readingTableView;
@property (weak, nonatomic) IBOutlet UITableView *hasReadTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSegment;

- (IBAction)showModeChanged:(id)sender;

@end
