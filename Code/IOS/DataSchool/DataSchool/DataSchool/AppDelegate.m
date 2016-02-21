//
//  AppDelegate.m
//  DataSchool
//
//  Created by Bergren Lam on 15/12/1.
//  Copyright (c) 2015年 AlexChen. All rights reserved.
//

#import "AppDelegate.h"

#import "IQKeyboardManager.h"
#import "IIViewDeckController.h"
#import "MenuViewController.h"
#import "ClassNameVC.h"
#import "SysRequest.h"
#import "UserMenu.h"
#import "NewsViewController.h"
#import "ClassInfoVC.h"
#import "AlbumViewController.h"
#import "UniversalVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize centerController = _viewController;
@synthesize leftController = _leftController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setStatusBarAndNavigationBar];
    [self setTabBarStyle];

    //[IQKeyboardManager installKeyboardManager];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;

    [UserManager userManager];
    
    //[self launchToLogin];
    
    if ([UserManager isLogin]) {
        [self launchToMainPage];
        //        if ([UserManager currentUser].iNewUser == 2) {
        //            [APPDELEGATE launchToMainPage];
        //        }else{
        //            [APPDELEGATE launchToReg];
        //        }
    } else {
        [self launchToLogin];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setStatusBarAndNavigationBar{
    
    //设置状态栏样式
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    //设置全局导航条风格和颜色
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:AppColorNavBkg]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    //设置导航栏文字颜色
    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:nil];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithHexString:AppColorNavBkg]];
    
    //设置导航栏文字颜色
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:20], NSFontAttributeName, nil]];
}

- (void)setTabBarStyle{
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    UIImage *bkgImg = [UIImage imageWithColor:[UIColor colorWithHexString:AppColorTabBarBkg] size:CGSizeMake(SCREEN_WIDTH, 50)];
    [[UITabBar appearance] setBackgroundImage:bkgImg];//[UIImage imageNamed:@"tabbar_bkg"]];
    //    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor lightGrayColor], UITextAttributeTextColor, nil]
    //                                             forState:UIControlStateNormal];
    UIImage *selectImg = [UIImage imageWithColor:[UIColor colorWithHexString:AppColorTabBarFocus] size:CGSizeMake(SCREEN_WIDTH/4, 50)];
    //UIImage *selectImg = [UIImage imageNamed:@"tabbar_focus"];
    [[UITabBar appearance] setSelectionIndicatorImage:selectImg];
}

- (void)launchToMainPage
{
    GetUserMenuRequest *getMenuRequest = [[GetUserMenuRequest alloc] init];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [getMenuRequest startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
        [SVProgressHUD dismiss];
        UserMenu *userMenu = request.parseResult;

        MenuViewController *leftController = (MenuViewController *)[UIViewController viewControllerWithStoryboard:@"MenuViewController" identifier:@"MenuView"];
        
        UINavigationController* centerController;
        Menu *menuItem = userMenu.Menus[0];
        if ([menuItem.MenuFunction isEqualToString:@"SchoolNew"]) {
            NewsViewController *newsVC = (NewsViewController *)[UIViewController viewControllerWithStoryboard:@"NewsViewController" identifier:@"NewsView"];
            centerController = [[UINavigationController alloc] initWithRootViewController:newsVC];
            newsVC.title = menuItem.MenuName;

        }else if([menuItem.MenuFunction isEqualToString:@"ClassNotice"]){
            ClassInfoVC *classInfo = (ClassInfoVC *)[UIViewController viewControllerWithStoryboard:@"ClassInfo" identifier:@"ClassInfoVC"];
            centerController = [[UINavigationController alloc] initWithRootViewController:classInfo];
            classInfo.title = menuItem.MenuName;

        }else if([menuItem.MenuType isEqualToString:kHTML]){
            //打开网页
            UniversalVC *universal = (UniversalVC *)[UIViewController viewControllerWithStoryboard:@"Universal" identifier:@"UniversalVC"];
            
            universal.mURL = menuItem.MenuFunction;
            universal.title = menuItem.MenuName;
            
            centerController = [[UINavigationController alloc] initWithRootViewController:universal];
            universal.title = menuItem.MenuName;

        }else if([menuItem.MenuFunction isEqualToString:@"Album"]){
            AlbumViewController *albumVC = (AlbumViewController *)[UIViewController viewControllerWithStoryboard:@"Album" identifier:@"AlbumVC"];
            centerController = [[UINavigationController alloc] initWithRootViewController:albumVC];
            albumVC.title = menuItem.MenuName;

        }
        
        leftController.mMenuArr = userMenu.Menus;
        [leftController.mTableView reloadData];
        
        IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:centerController
                                                                                        leftViewController:leftController];
        deckController.rightSize = 100;
        
        [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];

        self.leftController = deckController.leftController;
        self.centerController = deckController.centerController;

        self.window.rootViewController = deckController;
        [self.window makeKeyAndVisible];

    } failure:^(NSError *err) {
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
}

- (void)launchToLogin
{
    UIViewController *vc = [UIViewController viewControllerWithStoryboard:@"Login" identifier:@"LoginVCNav"];
    [self.window setRootViewController:vc];
}

- (void)setTanspNavigationAppearance:(UINavigationController *)nav
{
    //设置全透明
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent"] forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar  setShadowImage:[UIImage imageNamed:@"transparent"]];
    [nav.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    //设置导航栏文字颜色
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, nil]];
}

- (void)setNormalNavigationAppearance:(UINavigationController *)nav
{
    [nav.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setShadowImage:nil];
    [nav.navigationBar setBackgroundColor:[UIColor colorWithHexString:kAppColorNavBkg]];
    
    //设置导航栏文字颜色
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, nil]];
}

@end
