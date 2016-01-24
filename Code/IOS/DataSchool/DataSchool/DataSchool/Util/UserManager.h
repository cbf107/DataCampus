//
//  UserManager.h
//  MarketEleven
//
//  Created by coreyfu on 14-8-13.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//

#import "UserInfo.h"

@interface UserManager : NSObject

+ (instancetype)userManager;

/* after logining, call this method to adjust and save account and password
 */
+ (void)loginSuccessWithUserInfo:(UserInfo *)info;

/*
 Logs out the currently logged in user on disk.
 */
+ (void)logOut:(void (^)(void))finished;

/*
 verify current user if admin
 */
+(BOOL)isAdmin;

/*
 @result Returns whether the user is login.
 */
+ (BOOL)isLogin;
/*
 @para keyword search keyword, pass nil to return all users
 @result Returns users which have prefix: keyword.
 */
+ (NSArray *)userHasPrefix:(NSString *)keyword;

/* delete user which has #info infomation
 @para info user infomation dictionary:key is account, value is password
 */
+ (void)deleteUser:(UserInfo *)info;

/*
 @return user.
 */
+ (UserInfo *)currentUser;


+ (BOOL)handInvalidUser:(NSError *)err;

- (NSString*) getLastUserName;
@end
