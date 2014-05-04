//
//  BaseViewController.m
//  5Star
//
//  Created by Edward Zhang on 11-8-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import <objc/runtime.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"

static const CGFloat SVProgressHUDRingNoTextRadius = 24;

@implementation BaseViewController {
    UIImageView *_menuButtonImageView;
}

- (id)initWithRouterParams:(NSDictionary *)params {
    if (self = [super init]) {

    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterForground:) name:@"kNotificationAppEnterForeground" object:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)isSupportSwipePop {
    return YES;
}


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.backgroundColor = RGBCOLOR(239, 239, 244);
    [self setNavigationBackButton:nil];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:20]};

#if defined AccessibilityEnabled
    id LenderClass = [self class];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(LenderClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
//        NSLog(@"propertyName: %@", propertyName);
        if ([self respondsToSelector:@selector(propertyName)]) {
            id object = [self valueForKey:propertyName];
            if ([object isKindOfClass:[UIView class]]) {
                UIView *subview = (UIView *) object;
                subview.isAccessibilityElement = YES;
                subview.accessibilityLabel = propertyName;
            }
        }
    }
#endif
}

- (void)setClearsSelectionOnViewWillAppearForTableView:(UITableView *)tableView {
    if ([self respondsToSelector:@selector(setClearsSelectionOnViewWillAppear:)]) {
        [(UITableViewController *) self setClearsSelectionOnViewWillAppear:YES];
    } else {
        for (UIViewController *vc in self.childViewControllers) {
            if ([vc isKindOfClass:[UITableViewController class]]) {
                UITableViewController *tableViewController = (UITableViewController *) vc;
                if (tableViewController.tableView == tableView) {
                    tableViewController.clearsSelectionOnViewWillAppear = YES;
                    return;
                }
            }
        }
        UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:tableView.style];
        tvc.tableView = tableView;
        [self addChildViewController:tvc];
    }
}

- (UIRefreshControl *)refreshControlForTableView:(UITableView *)tableView {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor darkGrayColor];
    [refreshControl addTarget:self action:@selector(refreshInvoked:) forControlEvents:UIControlEventValueChanged];
    
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:[UITableViewController class]]) {
            UITableViewController *tableViewController = (UITableViewController *) vc;
            if (tableViewController.tableView == tableView) {
                tableViewController.refreshControl = refreshControl;
                return refreshControl;
            }
        }
    }

    // Create a UITableViewController so we can use a UIRefreshControl.
    UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:tableView.style];
    tvc.tableView = tableView;
    tvc.refreshControl = refreshControl;
    [self addChildViewController:tvc];
    
    return refreshControl;
}

- (void)backButtonTouchEvents:(id)sender {
    if (self.isPresent)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonTouchEvents:(id)sender {

}

- (void)showRoot {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect leftButtonImageViewFrame = _menuButtonImageView.frame;
        leftButtonImageViewFrame.size.width = 27;
        _menuButtonImageView.frame = leftButtonImageViewFrame;
    }];
}


- (void)setNavigationBackButton:(NSString*)_imageName{
    if (self.isPresent)
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTouchEvents:)];
    else{
//        if (_imageName) {
//            [self setNavigationLeftButton:_imageName selectImage:nil title:nil eventHandler:@selector(backButtonTouchEvents:)];//@"nav_back_yellow.png"
//        }else{
//
//            [self setNavigationLeftButton:@"nav_back_white.png" selectImage:nil title:nil eventHandler:@selector(backButtonTouchEvents:)];
//        }
    }

}

- (void)setNavigationBlankButton {
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)setNavigationLeftButtonWithTitle:(NSString *)title {
    [self setNavigationLeftButton:nil selectImage:nil title:title eventHandler:@selector(backButtonTouchEvents:)];
}

- (UIButton *)setNavigationLeftButton:(NSString *)_buttonImage selectImage:(NSString *)_selectImage title:(NSString *)title eventHandler:(SEL)eventHandler {
    [self.navigationItem hidesBackButton];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (_buttonImage) {
        UIImage *backimg = [UIImage imageNamed:_buttonImage];
        [btn setImage:backimg forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 60, 44);
        float leftEdge = (60-backimg.size.width)*0.5-10;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -leftEdge, 0, 0)];
    } else {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (_selectImage) {
        UIImage *backSelectImg = [UIImage imageNamed:_selectImage];
        [btn setImage:backSelectImg forState:UIControlStateHighlighted];
    }
    [btn addTarget:self action:eventHandler forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:btn]];
    return btn;
}

- (void)setNavigationRightButtonWithTitle:(NSString *)title {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonTouchEvents:)];
}

- (UIButton *)setNavigationRightButton:(NSString *)_buttonImage selectImage:(NSString *)_selectImage title:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (_buttonImage) {
        UIImage *backimg = [UIImage imageNamed:_buttonImage];
        [btn setImage:backimg forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 60, 44);
        float leftEdge = (60-backimg.size.width)*0.5-10;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, leftEdge, 0, 0)];
    } else {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:kButtonBackgroundColor forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 60, 44);
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    if (_selectImage) {
        UIImage *backSelectImg = [UIImage imageNamed:_selectImage];
        [btn setImage:backSelectImg forState:UIControlStateHighlighted];
    }
    [btn addTarget:self action:@selector(rightButtonTouchEvents:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:btn]];
    return btn;
}

- (void)setSelectedTabItem:(NSInteger)tabIndex {
//    [self.tabBar setSelectedItem:[self.tabBar items][tabIndex]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *pageViewName = self.title;
    if (!self.title || self.title.length == 0)
        pageViewName = self.pageViewName;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self setNavigationBarHidden];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSString *pageViewName = self.title;
    if (!self.title || self.title.length == 0)
        pageViewName = self.pageViewName;
}

- (void)setNavigationBarHidden
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)appEnterForground:(NSNotification *)notification {
    [self performSelector:@selector(deSelectTableViewCellForBack) withObject:nil afterDelay:0.2f];
}

- (void)deSelectTableViewCellForBack {
    if (self.backSelectedTableView && self.backSelectedIndexPath) {
        [UIView animateWithDuration:0.4 animations:^{
            [self.backSelectedTableView deselectRowAtIndexPath:self.backSelectedIndexPath animated:NO];
        }                completion:^(BOOL finished) {
            self.backSelectedTableView = nil;
            self.backSelectedIndexPath = nil;
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showActionSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
            initWithTitle:NSLocalizedString(@"registerActionSheetText", @"")
                 delegate:self
        cancelButtonTitle:NSLocalizedString(@"CancelRegisterActionSheet", @"")
   destructiveButtonTitle:@""
        otherButtonTitles:nil];

    [actionSheet showInView:self.view];
}

- (void)addContactUsRightButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [backBtn setBackgroundImage:[[UIImage imageNamed:@"nav_right_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)] forState:UIControlStateNormal];
    //[backBtn setBackgroundImage:[[UIImage imageNamed:@"nav_right_bg_selected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)] forState:UIControlStateHighlighted];
    [backBtn setTitle:NSLocalizedString(@"contactUs", @"") forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    backBtn.titleLabel.shadowOffset = CGSizeMake(0, -1);
    backBtn.titleLabel.shadowColor = [UIColor blackColor];

    [backBtn addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 75, 32);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backButton;
}

- (float)sizeParameter {
    float mheight = [[UIScreen mainScreen] bounds].size.height;
    if (mheight == 568.00)
        return 88;
    else
        return 0;
}

- (float)tableViewMaxHeight {
    float viewHeight = [[UIScreen mainScreen] bounds].size.height;
    //44=navigation height , 20=status height.
    float maxHeight = viewHeight - 44 - 20;
    return maxHeight;
}

- (void)openWeiXinService {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weixin.qq.com/r/rZ4ZFg3E1DOrhxx1n8uJ"]];
}

- (void)showLoading
{
    [self showLoadingWithStatus:nil];
}

- (void)showLoadingWithStatus:(NSString *)status
{
    CGFloat hudViewY = 100;
    CGFloat animatedLayerY = 21;
    if (status && status.length > 0) {
        hudViewY = 70;
        animatedLayerY = 0;
    }
    
    UIView *hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, hudViewY)];
    hudView.backgroundColor = [UIColor clearColor];
    CAShapeLayer *animatedLayer = [[self class] sharedAnimatedLayer];
    animatedLayer.frame = CGRectMake(21, animatedLayerY, animatedLayer.frame.size.width, animatedLayer.frame.size.height);
    [hudView.layer addSublayer:animatedLayer];
    
    [self showLoadingWithStatus:status customView:hudView];
}

- (void)showLoadingWithStatus:(NSString *)status customView:(UIView *)customView
{
    [self dismissLoadingAnimated:NO];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.dimBackground = NO;
    HUD.color = [UIColor colorWithWhite:0 alpha:0.6];
    HUD.labelColor = [UIColor whiteColor];
	[self.view addSubview:HUD];
	
    if (status && status.length > 0) {
        HUD.labelText = status;
    }
    
    HUD.customView = customView;
	HUD.mode = MBProgressHUDModeCustomView;
	
	[HUD show:YES];
}

- (void)showSuccessWithStatus:(NSString *)status
{
    UIView *hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 70)];
    hudView.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_success_white.png"]];
    CGRect imageViewFrame = imageView.frame;
    imageViewFrame.origin.x = (100-imageViewFrame.size.width) / 2;
    imageViewFrame.origin.y = (100-imageViewFrame.size.height) / 2 - 10;
    imageView.frame = imageViewFrame;
    [hudView addSubview:imageView];
    
    [self showLoadingWithStatus:status customView:hudView];
    [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:1];
}

- (void)showErrorWithStatus:(NSString *)status
{
    UIView *hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 70)];
    hudView.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_error_white.png"]];
    CGRect imageViewFrame = imageView.frame;
    imageViewFrame.origin.x = (100-imageViewFrame.size.width) / 2;
    imageViewFrame.origin.y = (100-imageViewFrame.size.height) / 2 - 10;
    imageView.frame = imageViewFrame;
    [hudView addSubview:imageView];
    
    [self showLoadingWithStatus:status customView:hudView];
    [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:1];
}

- (void)dismissLoading
{
    [self dismissLoadingAnimated:YES];
}

- (void)dismissLoadingAnimated:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:self.view animated:animated];
}

+ (CAShapeLayer*)sharedAnimatedLayer {
    static dispatch_once_t once;
    static CAShapeLayer *sharedLayer;
    dispatch_once(&once, ^ { sharedLayer = [[self class] indefiniteAnimatedLayer]; });
    return sharedLayer;
}

+ (CAShapeLayer*)indefiniteAnimatedLayer
{
    CGPoint center = CGPointMake(45, 45);
    CGFloat radius = SVProgressHUDRingNoTextRadius;
    CGPoint arcCenter = CGPointMake(radius+4/2+5, radius+4/2+5);
    CGRect rect = CGRectMake(center.x-radius, center.y-radius, arcCenter.x*2, arcCenter.y*2);
    
    UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                                radius:radius
                                                            startAngle:M_PI*3/2
                                                              endAngle:M_PI/2+M_PI*5
                                                             clockwise:YES];
    
    CAShapeLayer *_indefiniteAnimatedLayer = [CAShapeLayer layer];
    _indefiniteAnimatedLayer.contentsScale = [[UIScreen mainScreen] scale];
    _indefiniteAnimatedLayer.frame = rect;
    _indefiniteAnimatedLayer.fillColor = [UIColor clearColor].CGColor;
    _indefiniteAnimatedLayer.strokeColor = [UIColor whiteColor].CGColor;
    _indefiniteAnimatedLayer.lineWidth = 4;
    _indefiniteAnimatedLayer.lineCap = kCALineCapRound;
    _indefiniteAnimatedLayer.lineJoin = kCALineJoinBevel;
    _indefiniteAnimatedLayer.path = smoothedPath.CGPath;
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (id)[[UIImage imageNamed:@"loading_angle-mask@2x.png"] CGImage];
    maskLayer.frame = _indefiniteAnimatedLayer.bounds;
    _indefiniteAnimatedLayer.mask = maskLayer;
    
    NSTimeInterval animationDuration = 1;
    CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = 0;
    animation.toValue = [NSNumber numberWithFloat:M_PI*2];
    animation.duration = animationDuration;
    animation.timingFunction = linearCurve;
    animation.removedOnCompletion = NO;
    animation.repeatCount = INFINITY;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    [_indefiniteAnimatedLayer.mask addAnimation:animation forKey:@"rotate"];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = animationDuration;
    animationGroup.repeatCount = INFINITY;
    animationGroup.removedOnCompletion = NO;
    animationGroup.timingFunction = linearCurve;
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @0.015;
    strokeStartAnimation.toValue = @0.515;
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @0.485;
    strokeEndAnimation.toValue = @0.985;
    
    animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
    [_indefiniteAnimatedLayer addAnimation:animationGroup forKey:@"progress"];
    
    return _indefiniteAnimatedLayer;
}

@end
