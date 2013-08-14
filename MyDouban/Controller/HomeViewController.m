//
//  HomeViewController.m
//  MyDouban
//
//  Created by Leon on 13-8-9.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
{
    NSMutableArray *_bookList;
    NSMutableArray *_movieList;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    _bookList = [[NSMutableArray alloc] init];
    _movieList = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getHomeData
{
//    NSString *url = URL_BOOK_SEARCH;
//    NSDictionary *parameters = @{@"q":@(pageNum*pageSize)};
//    [SVProgressHUD show];
//    [[AFAppDotNetAPIClient sharedClient] getPath:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [SVProgressHUD dismiss];
//        if (pageNum == 0) {
//            [bookList removeAllObjects];
//        }
//        for (NSDictionary *dict in responseObject[@"collections"]) {
//            DBBook *book = [[DBBook alloc] initWithDic:dict];
//            [bookList addObject:book];
//        }
//        _hasNextArray[_showMode] = @(bookList.count < [responseObject[@"total"] intValue]);
//        [_tableViews[_showMode] reloadData];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [SVProgressHUD dismiss];
//        _hasNextArray[_showMode] = @(NO);
//    }];
}

- (void)searchWithText:(NSString *)searchText
{
    NSString *url = URL_BOOK_SEARCH;
    NSDictionary *parameters = @{@"q":searchText, @"count":@10};
    [SVProgressHUD show];
    [[AFAppDotNetAPIClient sharedClient] setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", THE_APPDELEGATE.accessToken]];
    [[AFAppDotNetAPIClient sharedClient] getPath:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [_bookList removeAllObjects];
        for (NSDictionary *dict in responseObject[@"books"]) {
            DBBook *book = [[DBBook alloc] initWithSearchDict:dict];
            [_bookList addObject:book];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - Table view data source

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"图书";
    else if (section == 1)
        return @"电影";
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return _bookList.count;
    else if (section == 1)
        return _movieList.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"BookCell";
        BookCell *cell = (BookCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        // Configure the cell...
        DBBook *book = _bookList[indexPath.row];
        [cell setBook:book];
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"MovieCell";
        MovieCell *cell = (MovieCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        DBMovie *movie = _movieList[indexPath.row];
        [cell setMovie:movie];
        return cell;
    }
    return nil;
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

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchWithText:searchBar.text];
    [searchBar resignFirstResponder];
}

#pragma mark - BookCellDelegate

- (void)bookStatusChanged:(DBBook *)book fromStatus:(DBBookStatus)status
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CAHNGE_STATUS object:@(book.status)];
    [self.tableView reloadData];
}

@end
