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

@property (nonatomic, weak) UIRefreshControl *refreshControl;

@end

@implementation BookViewController
{
    NSMutableDictionary *_bookListDict;
    DBBookStatus _showStatus;
    NSInteger _pageNum;
    NSInteger _pageSize;
    BOOL _hasNext;
}

- (void)resetData
{
    _pageNum = 0;
    _pageSize = 10;
    _hasNext = NO;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _bookListDict = [NSMutableDictionary new];
    [self resetData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasLogin:) name:NOTIFICATION_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasLogout:) name:NOTIFICATION_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChanged:) name:NOTIFICATION_CAHNGE_STATUS object:nil];
    
    [self.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"icon_book.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"icon_book_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"读书";

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.refreshControl = [self refreshControlForTableView:self.tableView];
    
    if (THE_APPDELEGATE.isLogin) {
        NSString *key = [NSString stringWithFormat:@"%d", _showStatus];
        _bookListDict[key] = [NSMutableArray new];
        [self getData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!THE_APPDELEGATE.isLogin) {
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginViewController] animated:YES completion:nil];
    }
}

- (void)statusChanged:(NSNotification *)notification
{
    [self reload];
}

- (void)getData
{
    if (THE_APPDELEGATE.isLogin) {
        NSString *key = [NSString stringWithFormat:@"%d", _showStatus];
        NSMutableArray *bookList = _bookListDict[key];
        
        NSString *url = [NSString stringWithFormat:URL_BOOK_COLLECTIONS, THE_APPDELEGATE.userId];
        NSString *status = @"";
        switch (_showStatus) {
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
        NSDictionary *parameters = @{@"start":@(_pageNum*_pageSize), @"count":@(_pageSize), @"status":status};
        if (_pageNum == 0)
            [self showLoading];
        [[AFAppDotNetAPIClient sharedClient] clearAuthorizationHeader];
        [[AFAppDotNetAPIClient sharedClient] getPath:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self dismissLoading];
            if (_pageNum == 0) {
                [bookList removeAllObjects];
            }
            for (NSDictionary *dict in responseObject[@"collections"]) {
                DBBook *book = [[DBBook alloc] initWithDict:dict];
                [bookList addObject:book];
            }
            _hasNext = (bookList.count < [responseObject[@"total"] intValue]);
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showErrorWithStatus:@"网络错误！"];
            _hasNext = NO;
        }];
    } else {
        [self.refreshControl endRefreshing];
    }
}

- (void)hasLogin:(NSNotification *)notification
{
    [self reload];
}

- (void)hasLogout:(NSNotification *)notification
{
    _bookListDict = [NSMutableDictionary new];
    [self resetData];
    [self.tableView reloadData];
}

- (void)reload
{
    _pageNum = 0;
    [self getData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 320, 10) animated:YES];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [NSString stringWithFormat:@"%d", _showStatus];
    return [_bookListDict[key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookCell";
    BookCell *cell = (BookCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    // Configure the cell...
    NSString *key = [NSString stringWithFormat:@"%d", _showStatus];
    NSMutableArray *bookList = _bookListDict[key];
    
    DBBook *book = bookList[indexPath.row];
    [cell setBook:book];
    cell.wantReadButton.tag = indexPath.row;
    cell.hasReadButton.tag = indexPath.row;
    cell.readingButton.tag = indexPath.row;
    
    if (indexPath.row == bookList.count-5 && _hasNext) {
        _pageNum += 1;
        [self getData];
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
        NSString *key = [NSString stringWithFormat:@"%d", _showStatus];
        DBBook *book = _bookListDict[key][indexPath.row];
        [book changeStatus:DBBookStatusNone success:^{
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        [_bookListDict[key] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

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
    [self setTableView:nil];
    [self setModeSegment:nil];
    [super viewDidUnload];
}

- (IBAction)showModeChanged:(id)sender
{
    [self resetData];
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    _showStatus = (DBBookStatus)segmentedControl.selectedSegmentIndex;
    
    NSString *key = [NSString stringWithFormat:@"%d", _showStatus];
    if (!_bookListDict[key]) {
        _bookListDict[key] = [NSMutableArray new];
        [self getData];
    } else {
        [self.tableView reloadData];
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 320, 10) animated:YES];
    }
}

- (IBAction)wantToReadTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *key = [NSString stringWithFormat:@"%d", _showStatus];
    DBBook *book = _bookListDict[key][button.tag];
    
    [self showLoading];
    [book changeStatus:DBBookStatusWantRead success:^{
        [self dismissLoading];
        NSString *newkey = [NSString stringWithFormat:@"%d", DBBookStatusWantRead];
        [_bookListDict[newkey] insertObject:book atIndex:0];
        
        [_bookListDict[key] removeObject:book];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:button.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorWithStatus:@"网络错误！"];
    }];
}

- (IBAction)readingTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *key = [NSString stringWithFormat:@"%d", _showStatus];
    DBBook *book = _bookListDict[key][button.tag];
    
    [self showLoading];
    [book changeStatus:DBBookStatusReading success:^{
        [self dismissLoading];
        NSString *newkey = [NSString stringWithFormat:@"%d", DBBookStatusReading];
        [_bookListDict[newkey] insertObject:book atIndex:0];
        
        [_bookListDict[key] removeObject:book];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:button.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorWithStatus:@"网络错误！"];
    }];
}

- (IBAction)hasReadTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *key = [NSString stringWithFormat:@"%d", _showStatus];
    DBBook *book = _bookListDict[key][button.tag];
    
    [self showLoading];
    [book changeStatus:DBBookStatusHasRead success:^{
        [self dismissLoading];
        NSString *newkey = [NSString stringWithFormat:@"%d", DBBookStatusHasRead];
        [_bookListDict[newkey] insertObject:book atIndex:0];
        
        [_bookListDict[key] removeObject:book];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:button.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorWithStatus:@"网络错误！"];
    }];
}

- (void)refreshInvoked:(UIRefreshControl *)refreshControl
{
    [self reload];
}

@end
