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
    
    UIButton *webButton = [UIButton buttonWithTitle:@"去网页版" positionY:250];
    [webButton addTarget:self action:@selector(webButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:webButton];
}

- (void)innerInit
{
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)webButtonTapped:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://movie.douban.com"]];
}

@end
