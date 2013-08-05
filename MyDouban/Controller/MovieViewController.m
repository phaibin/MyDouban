//
//  MovieViewController.m
//  MyDouban
//
//  Created by Leon on 13-8-1.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import "MovieViewController.h"
#import "DBBook.h"

@interface MovieViewController ()

@property (nonatomic, strong) NSMutableArray *bookList;

@end

@implementation MovieViewController
{
    int _pageNum;
    int _pageSize;
    BOOL _hasNext;
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
    _pageNum = 0;
    _pageSize = 10;
     [self.navigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_movie_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_movie.png"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"电影";
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (THE_APPDELEGATE.accessToken && THE_APPDELEGATE.accessToken.length > 0) {
        [self getData];
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
    NSDictionary *parameters = @{@"start": @(_pageNum*_pageSize)};
    [[AFAppDotNetAPIClient sharedClient] getPath:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (NSDictionary *dict in responseObject[@"collections"]) {
            DBBook *book = [[DBBook alloc] initWithDic:dict];
            [self.bookList addObject:book];
        }
        _hasNext = self.bookList.count < [responseObject[@"total"] intValue];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MovieCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    DBBook *book = self.bookList[indexPath.row];
    cell.textLabel.text = book.name;
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

@end
