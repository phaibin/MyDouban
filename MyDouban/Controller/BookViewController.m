//
//  BookViewController.m
//  MyDouban
//
//  Created by Leon on 13-8-1.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import "BookViewController.h"
#import "LoginViewController.h"
#import "DBBook.h"
#import <QuartzCore/QuartzCore.h>

@interface BookViewController ()

@property (nonatomic, weak) UIRefreshControl *wantReadRefreshControl;
@property (nonatomic, weak) UIRefreshControl *readingRefreshControl;
@property (nonatomic, weak) UIRefreshControl *hasReadRefreshControl;

@end

@implementation BookViewController
{
    NSMutableArray *_pageNumArray;
    NSMutableArray *_pageSizeArray;
    NSMutableArray *_hasNextArray;
    NSMutableArray *_bookListArray;
    NSArray *_tableViews;
    NSArray *_refreshControls;

    DBBookStatus _showStatus;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    [self resetData];
    
    [self.navigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_book_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_book.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasLogin:) name:NOTIFICATION_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasLogout:) name:NOTIFICATION_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChanged:) name:NOTIFICATION_CAHNGE_STATUS object:nil];
}

- (void)resetData
{
    _pageNumArray = [NSMutableArray arrayWithArray:@[@(0), @(0), @(0)]];
    _pageSizeArray = [NSMutableArray arrayWithArray:@[@(10), @(10), @(10)]];
    _hasNextArray = [NSMutableArray arrayWithArray:@[@(NO), @(NO), @(NO)]];
    _bookListArray = [NSMutableArray arrayWithArray:@[[[NSMutableArray alloc] init], [[NSMutableArray alloc] init], [[NSMutableArray alloc] init]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"读书";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.coverView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.coverView.layer.shadowOpacity = 0.8;
    self.coverView.layer.shadowRadius = 6;
    
    _tableViews = @[self.wantReadTableView, self.readingTableView, self.hasReadTableView];
    
    self.wantReadRefreshControl = [self refreshControlForTableView:self.wantReadTableView];
    self.readingRefreshControl = [self refreshControlForTableView:self.readingTableView];
    self.hasReadRefreshControl = [self refreshControlForTableView:self.hasReadTableView];
    _refreshControls = @[self.wantReadRefreshControl, self.readingRefreshControl, self.hasReadRefreshControl];
    
    if (THE_APPDELEGATE.accessToken && THE_APPDELEGATE.accessToken.length > 0) {
        [self getDataWithIndex:_showStatus];
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginViewController] animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)statusChanged:(NSNotification *)notification
{
    [self reloadWithStatus:[notification.object intValue]];
}

- (void)getDataWithIndex:(int)index
{
    NSString *url = [NSString stringWithFormat:URL_BOOK_COLLECTIONS, THE_APPDELEGATE.userId];
    int pageNum = [_pageNumArray[index] intValue];
    int pageSize = [_pageSizeArray[index] intValue];
    NSMutableArray *bookList = _bookListArray[index];
    NSString *status = @"";
    switch (index) {
        case DBBookStatusWantRead:
            status = @"wish";
            break;
        case DBBookStatusReading:
            status = @"reading";
            break;
        case DBBookStatusHasRead:
            status = @"read";
            break;
        default:
            break;
    }
    NSDictionary *parameters = @{@"start":@(pageNum*pageSize), @"count":@(pageSize), @"status":status};
    if (pageNum == 0)
        [SVProgressHUD show];
    [[AFAppDotNetAPIClient sharedClient] clearAuthorizationHeader];
    [[AFAppDotNetAPIClient sharedClient] getPath:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if (pageNum == 0) {
            [bookList removeAllObjects];
        }
        for (NSDictionary *dict in responseObject[@"collections"]) {
            DBBook *book = [[DBBook alloc] initWithDict:dict];
            [bookList addObject:book];
        }
        _hasNextArray[index] = @(bookList.count < [responseObject[@"total"] intValue]);
        [_tableViews[index] reloadData];
        [_refreshControls[index] endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        _hasNextArray[index] = @(NO);
    }];
}

- (void)hasLogin:(NSNotification *)notification
{
    [self reloadWithStatus:DBBookStatusWantRead];
}

- (void)hasLogout:(NSNotification *)notification
{
    [self resetData];
    for (UITableView *tableView in _tableViews) {
        [tableView reloadData];
    }
}

- (void)reloadWithStatus:(DBBookStatus)status
{
    _showStatus = status;
    _pageNumArray[_showStatus] = @0;
    [self getDataWithIndex:_showStatus];
    [self switchTableView];
    self.modeSegment.selectedSegmentIndex = _showStatus;
    [_tableViews[_showStatus] scrollRectToVisible:CGRectMake(0, 0, 320, 10) animated:YES];
}

- (UIRefreshControl *)refreshControlForTableView:(UITableView *)tableView
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor darkGrayColor];
    refreshControl.tag = [_tableViews indexOfObject:tableView];
    [refreshControl addTarget:self action:@selector(refreshInvoked:) forControlEvents:UIControlEventValueChanged];
    
    // Create a UITableViewController so we can use a UIRefreshControl.
    UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:tableView.style];
    tvc.tableView = tableView;
    tvc.refreshControl = refreshControl;
    [self addChildViewController:tvc];
    
    return refreshControl;
}

#pragma mark - Table view data source

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int index = [_tableViews indexOfObject:tableView];
    return [_bookListArray[index] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookCell";
    BookCell *cell = (BookCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    // Configure the cell...
    int index = [_tableViews indexOfObject:tableView];
    DBBook *book = _bookListArray[index][indexPath.row];
    [cell setBook:book];
    
    if (indexPath.row == [_bookListArray[index] count]-5 && [_hasNextArray[index] boolValue]) {
        _pageNumArray[index] = @([_pageNumArray[index] intValue] + 1);
        [self getDataWithIndex:index];
    }
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        int index = [_tableViews indexOfObject:tableView];
        DBBook *book = _bookListArray[index][indexPath.row];
        [book changeStatus:DBBookStatusNone success:^{
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        [_bookListArray[index] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)viewDidUnload {
    [self setWantReadTableView:nil];
    [self setReadingTableView:nil];
    [self setHasReadTableView:nil];
    [self setModeSegment:nil];
    [self setCoverView:nil];
    [super viewDidUnload];
}

- (IBAction)showModeChanged:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    _showStatus = segmentedControl.selectedSegmentIndex;
    [self switchTableView];
}

- (void)switchTableView
{
    self.wantReadTableView.hidden = YES;
    self.readingTableView.hidden = YES;
    self.hasReadTableView.hidden = YES;
    UITableView *tableView = _tableViews[_showStatus];
    tableView.hidden = NO;
    [tableView reloadData];
    if (THE_APPDELEGATE.isLogin && [_bookListArray[_showStatus] count] == 0)
        [self getDataWithIndex:_showStatus];
}

#pragma mark - BookCellDelegate

- (void)bookStatusChanged:(DBBook *)book fromStatus:(DBBookStatus)status
{
    [_bookListArray[status] removeObject:book];
    [_tableViews[status] reloadData];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self reloadWithStatus:book.status];
    });
}

- (void)refreshInvoked:(UIRefreshControl *)refreshControl
{
    [self reloadWithStatus:refreshControl.tag];
}

@end
