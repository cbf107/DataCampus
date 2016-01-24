//
//  UserManager.m
//  MarketEleven
//
//  Created by coreyfu on 14-8-13.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//
#import <AdSupport/AdSupport.h>
#import "UserManager.h"
#import "SysRequest.h"
#import "AppDelegate.h"

#define kUserListKey @"userListKey"//存储已登录用户名和密码
#define MAX_USER_COUNT 5

static BOOL sIsLogin;
static BOOL sInvalidUserHanding;

@interface UserManager ()

@property (nonatomic,strong) NSMutableArray *userList;
@property (nonatomic,strong) UserInfo *userInfo;
@property (nonatomic,copy) NSString *userInfoPath;

@end


@implementation UserManager

+ (instancetype)userManager
{
    static dispatch_once_t onceToken;
    static UserManager *manager = nil;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initSingleton];
    });
    
    return manager;
}

- (id)initSingleton
{
    self = [super init];
    
    if (self){
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _userInfoPath = [documentsDirectory stringByAppendingPathComponent:kUserListKey];
        NSArray *list = [NSKeyedUnarchiver unarchiveObjectWithFile:_userInfoPath];
        
        sIsLogin = NO;
        sInvalidUserHanding = NO;
        
        if (list && list.count > 0) {
            _userList = [[NSMutableArray alloc] initWithArray:list];
            _userInfo = _userList[0];
            if (_userInfo.UserRefId && _userInfo.UserRefId.length>0) {
                sIsLogin = YES;
            }
        }else{
            _userList = [[NSMutableArray alloc] init];
        }
    }
    
    return self;
}

- (id)init
{
    
    NSAssert(NO, @"这是一个严格单例，禁止初始化，请直接调用类方法");
    
    return nil;
    
}

+ (BOOL)isLogin
{
    return sIsLogin;
}

+ (UserInfo *)currentUser
{
    return [UserManager userManager].userInfo;
}

+ (void)loginSuccessWithUserInfo:(UserInfo *)info
{
    
    UserManager *manager = [UserManager userManager];
    [manager loginSuccess:info];

}

+(BOOL)isAdmin{
    BOOL result = NO;
    UserInfo *userInfo = [UserManager userManager].userInfo;
    /*for (int i = 0; i < userInfo.tRole.count; i++) {
        role *Role = [userInfo.tRole objectAtIndex:i];
        if ([Role.sMethod isEqualToString:@"update"]) {
            result = YES;
            break;
        }
    }*/
    
    return result;
}


+ (void)logOut:(void (^)(void))finished
{
    UserLogoutRequest *request = [[UserLogoutRequest alloc] init];
    //UserInfo *userInfo = [UserManager currentUser];
    //request.sUserRefId = userInfo.sUserRefId;
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        [[UserManager userManager] logOut];
        
        if (finished) {
            finished();
        }
    } failure:^(NSError *err) {

        [[UserManager userManager] logOut];
        
        if (finished) {
            finished();
        }
    }];
    
}


- (void)loginSuccess:(UserInfo *)info
{
    self.userInfo = info;
    
    sIsLogin = YES;
    sInvalidUserHanding = NO;

    [self.userList enumerateObjectsUsingBlock:^(UserInfo *obj, NSUInteger idx, BOOL *stop) {
        
        if (obj.UserId  == info.UserId) {
            [self.userList removeObject:obj];
            *stop = YES;
        }
    }];
    
    if (self.userList.count == MAX_USER_COUNT) {
        [self.userList removeLastObject];
    }
    
    [self.userList insertObject:info atIndex:0];
    
    BOOL ret = [NSKeyedArchiver archiveRootObject:self.userList toFile:self.userInfoPath];
    NSLog(@"\n保存用户信息%@\n",(ret == YES)?@"成功":@"失败");
}

- (void)logOut
{

    UserInfo *userInfo = self.userInfo;
    
    sIsLogin = NO;
    
    [self.userList enumerateObjectsUsingBlock:^(UserInfo *obj, NSUInteger idx, BOOL *stop) {
        
        if (obj.UserId  == userInfo.UserId) {
            obj.UserRefId = nil;
            //obj.pid = nil;pid不能清除，用于唯一标识已登录过用户
            *stop = YES;
        }
    }];
    
    BOOL ret = [NSKeyedArchiver archiveRootObject:self.userList toFile:self.userInfoPath];
    NSLog(@"\n保存用户信息%@\n",(ret == YES)?@"成功":@"失败");
    
    self.userInfo = nil;
    
    [YTKRequest cleanRequestCache];
}

- (void)removeUser:(UserInfo *)i
{
    
    [self.userList enumerateObjectsUsingBlock:^(UserInfo *obj, NSUInteger idx, BOOL *stop) {

        if (obj.UserId  == i.UserId) {
            [self.userList removeObject:obj];
            *stop = YES;
        }
    }];
    
    BOOL ret = [NSKeyedArchiver archiveRootObject:self.userList toFile:self.userInfoPath];
    NSLog(@"\n保存用户信息%@\n",(ret == YES)?@"成功":@"失败");
}

+ (NSArray *)userHasPrefix:(NSString *)keyword
{
    NSArray *list = [UserManager userManager].userList;
    
    if (keyword.length == 0) return list;
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (UserInfo *user in list) {
        if ([user.UserId hasPrefix:keyword]) {
            [result addObject:user];
        }
    }
    
    return result;
}

+ (void)deleteUser:(UserInfo *)info
{
    [[UserManager userManager] removeUser:info];
}


+ (BOOL)handInvalidUser:(NSError *)err
{
    if (err && [err.domain isEqualToString:IWanDaErrorDomain] && (err.code == IWanDaRequestInvalidUser)) {
        [SVProgressHUD dismiss];
        if (!sInvalidUserHanding) {
            sInvalidUserHanding = YES;
            [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前账号无效，请重新登录" delegate:[UserManager userManager] cancelButtonTitle:@"退出" otherButtonTitles:@"重新登录", nil] show];
        }
        
        return YES;
    }
    
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self exitApplication];
    } else {
        UIViewController *launchVC = [UIViewController viewControllerWithStoryboard:@"Main" identifier:@"MainNav"];
        [APPDELEGATE.window setRootViewController:launchVC];
    }
//    UITabBarController *tab = (UITabBarController *)APPDELEGATE.window.rootViewController;
//    UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
//    
//    if (buttonIndex == 0) {
//        [UserManager logOut:^{
//            
//            if ([nav.topViewController isKindOfClass:[MineVC class]]) {//当前界面在个人中心刷新登录状态
//                MineVC *mine = (MineVC *)nav.topViewController;
//                [mine checkLoginState];
//            }else if ([nav.viewControllers[0] isKindOfClass:[HomeViewController class]]) {
//                [APPDELEGATE setHomeNavigationAppearance:nav];
//            }
//            
//            [nav popToRootViewControllerAnimated:YES];
//        }];
//    }else if(buttonIndex == 1){
//        [UserManager logOut:^{
//            [nav.topViewController presentLoginVCWithLoginSuccessHandle:^{
//                //[nav popViewControllerAnimated:NO];//回到上级页面，重新加载
//            } cancelHandle:^{
//                sInvalidUserHanding = NO;
//            }];
//        }];
//    }
}

- (NSString*) getLastUserName {
    NSArray *list = [UserManager userManager].userList;
    
    if (list && list.count>0) {
        return ((UserInfo *)list[0]).UserId;
    } else {
        return @"";
    }
}


//-------------------------------- 退出程序 -----------------------------------------//

- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
    // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:APPDELEGATE.window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    //self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    APPDELEGATE.window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
    
}



- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}


@end
