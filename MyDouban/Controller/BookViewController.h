//
//  BookViewController.h
//  MyDouban
//
//  Created by Leon on 13-8-1.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *wantReadTableView;
@property (weak, nonatomic) IBOutlet UITableView *readingTableView;
@property (weak, nonatomic) IBOutlet UITableView *hasReadTableView;

- (IBAction)showModeChanged:(id)sender;

@end
