//
//  MyDoubanViewController.m
//  MyDouban
//
//  Created by Leon on 13-8-1.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import "MyDoubanViewController.h"
#import "LoginViewController.h"
#import "UIBarButtonItem+Extension.h"
#import <QuartzCore/QuartzCore.h>
#import "UserInfo.h"
#import "UIImageView+WebCache.h"

@interface MyDoubanViewController ()

@end

@implementation MyDoubanViewController
{
    UserInfo *_userInfo;
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
    [self.navigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_mydouban_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_mydouban.png"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasLogin:) name:NOTIFICATION_LOGIN object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的豆瓣";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.headerImageView.layer.cornerRadius = 3;
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.layer.borderWidth = 1;
    self.headerImageView.layer.borderColor = [UIColor grayColor].CGColor;
    
    if (THE_APPDELEGATE.userId) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"退出" style:ExtendBarButtonItemStyleBlue target:self action:@selector(logoutTapped:)];
        [self getData];
    } else {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"登录" style:ExtendBarButtonItemStyleBlue target:self action:@selector(loginTapped:)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData
{
    NSString *url = [NSString stringWithFormat:URL_USER_INFO, THE_APPDELEGATE.userId];
    [SVProgressHUD show];
    [[AFAppDotNetAPIClient sharedClient] clearAuthorizationHeader];
    [[AFAppDotNetAPIClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        _userInfo = [[UserInfo alloc] initWithDict:responseObject];
        
        __weak typeof(self) weakSelf = self;
        [weakSelf.headerImageView setImageWithURL:[NSURL URLWithString:_userInfo.avatarUrl] placeholderImage:[UIImage imageNamed:@"default_avatar.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                weakSelf.headerImageView.image = image;
                if (cacheType == SDImageCacheTypeNone) {
                    weakSelf.headerImageView.alpha = 0;
                    [UIView animateWithDuration:0.3 animations:^{
                        weakSelf.headerImageView.alpha = 1;
                    }];
                }
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)clear
{
    
}

- (void)hasLogin:(NSNotification *)notification
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"退出" style:ExtendBarButtonItemStyleBlue target:self action:@selector(logoutTapped:)];
    [self getData];
}

- (IBAction)loginTapped:(id)sender
{
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginViewController] animated:YES completion:nil];
}

- (IBAction)logoutTapped:(id)sender
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"登录" style:ExtendBarButtonItemStyleBlue target:self action:@selector(loginTapped:)];
    [self clear];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGOUT object:nil];
}

- (void)viewDidUnload {
    [self setHeaderImageView:nil];
    [self setNameLabel:nil];
    [self setJoinLabel:nil];
    [self setDescLabel:nil];
    [super viewDidUnload];
}

@end
