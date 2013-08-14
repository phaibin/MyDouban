//
//  AppDelegate.m
//  MyDouban
//
//  Created by Leon on 13-7-31.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)isLogin
{
    return self.accessToken != nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_ACCESSTOKEN];
    self.refreshToken = [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_REFRESHTOKEN];
    self.userId = [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_USERID];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_tabBar.png"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selection.png"]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithWhite:0.5 alpha:1], UITextAttributeTextColor, [UIColor blackColor], UITextAttributeTextShadowColor, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithWhite:0.85 alpha:1], UITextAttributeTextColor, [UIColor blackColor], UITextAttributeTextShadowColor, nil] forState:UIControlStateSelected];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_topBar.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *backButtonImage = [[UIImage imageNamed:@"icon_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, backButtonImage.size.height*2) forBarMetrics:UIBarMetricsDefault];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasLogout:) name:NOTIFICATION_LOGOUT object:nil];
    
    return YES;
}

- (void)hasLogout:(NSNotification *)notification
{
    self.accessToken = nil;
    self.refreshToken = nil;
    self.userId = nil;

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DEFAULTS_ACCESSTOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DEFAULTS_REFRESHTOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DEFAULTS_USERID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
