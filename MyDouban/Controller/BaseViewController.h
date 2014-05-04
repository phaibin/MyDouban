//
//  BaseViewController.h
//  5Star
//
//  Created by Edward Zhang on 11-8-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WeiXinServiceCellHeigh  130

enum {
    TAB_HOTEL,
    TAB_ORDER,
    TAB_SHARE,
    TAB_ACCOUNT
};

@interface BaseViewController : UIViewController <UITabBarDelegate, UIActionSheetDelegate> {

}

@property(weak, nonatomic) UIViewController *fromController;
@property(strong, nonatomic) NSString *viewNameForGA;
//@property (strong, nonatomic) UITabBar         *tabBar;
@property(assign, nonatomic) float tableViewMaxHeight;
@property(strong, nonatomic) UIView *blackView;

@property(nonatomic, strong) UITableView *backSelectedTableView;
@property(nonatomic, strong) NSIndexPath *backSelectedIndexPath;
@property(nonatomic, assign) BOOL isPresent;
@property (nonatomic, copy) NSString *pageViewName;

- (void)addContactUsRightButton;

//nav left button
- (void)backButtonTouchEvents:(id)sender;

- (void)setNavigationLeftButtonWithTitle:(NSString *)title;

- (void)setNavigationRightButtonWithTitle:(NSString *)title;

- (UIButton *)setNavigationLeftButton:(NSString *)_buttonImage selectImage:(NSString *)_selectImage title:(NSString *)title eventHandler:(SEL)eventHandler;

- (UIButton *)setNavigationRightButton:(NSString *)_buttonImage selectImage:(NSString *)_selectImage title:(NSString *)title;

- (void)setNavigationBlankButton;

- (void)setNavigationBackButton:(NSString*)_imageName;

//nav right button
- (void)rightButtonTouchEvents:(id)sender;

- (void)appEnterForground:(NSNotification *)notification;

- (void)openWeiXinService;

- (UIRefreshControl *)refreshControlForTableView:(UITableView *)tableView;

- (void)setClearsSelectionOnViewWillAppearForTableView:(UITableView *)tableView;


- (void)showLoading;
- (void)showLoadingWithStatus:(NSString *)status;
- (void)showSuccessWithStatus:(NSString *)status;
- (void)showErrorWithStatus:(NSString *)status;
- (void)dismissLoading;

@end


@interface BaseViewController (
private)

- (void)gaTrackCustomVariableByName:(NSString *)name value:(NSString *)value index:(NSInteger)index;

- (void)setSelectedTabItem:(NSInteger)tabIndex;

@end

@interface BaseViewController (optional)
- (void)userLocationRefresh;

- (float)sizeParameter;
@end