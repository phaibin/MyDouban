//
//  SearchViewController.h
//  MyDouban
//
//  Created by Leon on 13-8-5.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *searchField;

- (IBAction)searchTapped:(id)sender;

@end
