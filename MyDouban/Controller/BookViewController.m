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

@interface BookViewController ()

@end

@implementation BookViewController
{
    NSMutableArray *_pageNumArray;
    NSMutableArray *_pageSizeArray;
    NSMutableArray *_hasNextArray;
    NSMutableArray *_bookListArray;
    NSArray *_tableViews;

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
    _tableViews = @[self.wantReadTableView, self.readingTableView, self.hasReadTableView];
    if (THE_APPDELEGATE.accessToken && THE_APPDELEGATE.accessToken.length > 0) {
        [self getData];
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

- (void)getData
{
    NSString *url = [NSString stringWithFormat:URL_BOOK_COLLECTIONS, THE_APPDELEGATE.userId];
    int pageNum = [_pageNumArray[_showStatus] intValue];
    int pageSize = [_pageSizeArray[_showStatus] intValue];
    NSMutableArray *bookList = _bookListArray[_showStatus];
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
    NSDictionary *parameters = @{@"start":@(pageNum*pageSize), @"count":@(pageSize), @"status":status};
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
        _hasNextArray[_showStatus] = @(bookList.count < [responseObject[@"total"] intValue]);
        [_tableViews[_showStatus] reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        _hasNextArray[_showStatus] = @(NO);
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
    [self getData];
    [self switchTableView];
    self.modeSegment.selectedSegmentIndex = _showStatus;
    [_tableViews[_showStatus] scrollRectToVisible:CGRectMake(0, 0, 320, 10) animated:YES];
}

#pragma mark - Table view data source

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_bookListArray[_showStatus] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookCell";
    BookCell *cell = (BookCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    // Configure the cell...
    DBBook *book = _bookListArray[_showStatus][indexPath.row];
    [cell setBook:book];
    
    if (indexPath.row == [_bookListArray[_showStatus] count]-5 && [_hasNextArray[_showStatus] boolValue]) {
        _pageNumArray[_showStatus] = @([_pageNumArray[_showStatus] intValue] + 1);
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
        DBBook *book = _bookListArray[_showStatus][indexPath.row];
        [book changeStatus:DBBookStatusNone success:^{
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        [_bookListArray[_showStatus] removeObjectAtIndex:indexPath.row];
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
        [self getData];
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

@end
