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
#import "UIImageView+WebCache.h"

@interface BookViewController ()

@property (nonatomic, strong) NSMutableArray *bookList;

@end

@implementation BookViewController
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
    NSDictionary *parameters = @{@"start": @(_pageNum*_pageSize)};
    [SVProgressHUD show];
    [[AFAppDotNetAPIClient sharedClient] getPath:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if (_pageNum == 0) {
            [self.bookList removeAllObjects];
        }
        for (NSDictionary *dict in responseObject[@"collections"]) {
            DBBook *book = [[DBBook alloc] initWithDic:dict];
            [self.bookList addObject:book];
        }
        _hasNext = self.bookList.count < [responseObject[@"total"] intValue];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        _hasNext = NO;
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookCell";
    BookCell *cell = (BookCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    DBBook *book = self.bookList[indexPath.row];
    cell.nameLabel.text = book.name;
    cell.authorLabel.text = [book.authors componentsJoinedByString:@" "];
    __weak typeof(cell) weakCell = cell;
    [weakCell.coverImageView setImageWithURL:[NSURL URLWithString:book.coverImageUrl] placeholderImage:[UIImage imageNamed:@"book_default.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            weakCell.coverImageView.image = image;
            if (cacheType == SDImageCacheTypeNone) {
                weakCell.coverImageView.alpha = 0;
                [UIView animateWithDuration:0.3 animations:^{
                    weakCell.coverImageView.alpha = 1;
                }];
            }
        }
    }];
    
    if (indexPath.row == self.bookList.count-5 && _hasNext) {
        _pageNum++;
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

@end
