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
#import "BookCell.h"

#define ShowModeWantRead    0
#define ShowModeReading     1
#define ShowModeHasRead     2

@interface BookViewController ()

@end

@implementation BookViewController
{
    NSMutableArray *_pageNumArray;
    NSMutableArray *_pageSizeArray;
    NSMutableArray *_hasNextArray;
    NSMutableArray *_bookListArray;
    NSArray *_tableViews;

    int _showMode;
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
    _pageNumArray = [NSMutableArray arrayWithArray:@[@(0), @(0), @(0)]];
    _pageSizeArray = [NSMutableArray arrayWithArray:@[@(10), @(10), @(10)]];
    _hasNextArray = [NSMutableArray arrayWithArray:@[@(NO), @(NO), @(NO)]];
    _bookListArray = [NSMutableArray arrayWithArray:@[[[NSMutableArray alloc] init], [[NSMutableArray alloc] init], [[NSMutableArray alloc] init]]];
    
    [self.navigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_book_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_book.png"]];
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

- (void)getData
{
    NSString *url = [NSString stringWithFormat:URL_BOOK_COLLECTIONS, THE_APPDELEGATE.userId];
    int pageNum = [_pageNumArray[_showMode] intValue];
    int pageSize = [_pageSizeArray[_showMode] intValue];
    NSMutableArray *bookList = _bookListArray[_showMode];
    NSString *status = @"";
    switch (_showMode) {
        case ShowModeWantRead:
            status = @"wish";
            break;
        case ShowModeReading:
            status = @"reading";
            break;
        case ShowModeHasRead:
            status = @"read";
            break;
        default:
            break;
    }
    NSDictionary *parameters = @{@"start":@(pageNum*pageSize), @"count":@(pageSize), @"status":status};
    [SVProgressHUD show];
    [[AFAppDotNetAPIClient sharedClient] getPath:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if (pageNum == 0) {
            [bookList removeAllObjects];
        }
        for (NSDictionary *dict in responseObject[@"collections"]) {
            DBBook *book = [[DBBook alloc] initWithDict:dict];
            [bookList addObject:book];
        }
        _hasNextArray[_showMode] = @(bookList.count < [responseObject[@"total"] intValue]);
        [_tableViews[_showMode] reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        _hasNextArray[_showMode] = @(NO);
    }];
}

#pragma mark - Table view data source

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_bookListArray[_showMode] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookCell";
    BookCell *cell = (BookCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    DBBook *book = _bookListArray[_showMode][indexPath.row];
    [cell setBook:book];
    
    if (indexPath.row == [_bookListArray[_showMode] count]-5 && [_hasNextArray[_showMode] boolValue]) {
        _pageNumArray[_showMode] = @([_pageNumArray[_showMode] intValue] + 1);
        [self getData];
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    [super viewDidUnload];
}

- (IBAction)showModeChanged:(id)sender
{
    self.wantReadTableView.hidden = YES;
    self.readingTableView.hidden = YES;
    self.hasReadTableView.hidden = YES;
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    _showMode = segmentedControl.selectedSegmentIndex;
    UITableView *tableView = _tableViews[_showMode];
    tableView.hidden = NO;
    [tableView reloadData];
    if ([_bookListArray[_showMode] count] == 0)
        [self getData];
}

@end
