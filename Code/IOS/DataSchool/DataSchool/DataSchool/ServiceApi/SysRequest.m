//
//  CommonRequest.m
//  WanDa
//
//  Created by coreyfu on 15/7/21.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "SysRequest.h"
#import "UserProfile.h"
#import "UserMenu.h"
#import "ClassNotice.h"
#import "EventType.h"
//#import "SysCode.h"

/*@implementation SysCodeRequest
- (NSString *)requestUrl {
    return kApiSysCode;
}

- (id)requestParameters {
    return @{@"iType":self.iType>0?@(self.iType):[NSNull null],
             @"iParentId":self.iParentId>0?@(self.iParentId):[NSNull null],
             @"iId":self.iId>0?@(self.iId):[NSNull null],
             @"page":@(self.page),
             @"rows":@(self.rows)};
}

- (id)parseResult {
    id result = self.responseBodyJSON;
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        return [[SysCodes alloc] initWithDictionary:result error:nil].sysCode;
    }
    return nil;
}
@end*/

//login
@implementation UserLoginRequest
- (NSString *)requestUrl {
    return kApiLogin;
}

- (id)requestParameters {
    return @{@"UserId":self.UserId?:[NSNull null],
             @"Password":self.Password?:[NSNull null],
             @"MemberRefId":self.MemberRefId?:[NSNull null]};
}

- (id)parseResult {
    id result = self.responseBodyJSON;
    if ([result isKindOfClass:[NSDictionary class]]) {
        UserInfo *userInfo = [[UserInfo alloc] initWithDictionary:result error:nil];
        
        return userInfo;
    }
    return nil;
}
@end

//user profile
@implementation GetUserProfileRequest
- (NSString *)requestUrl {
    return kApiGetProfile;
}

- (id)requestParameters {
    return @{};
}

- (id)parseResult {
    id result = self.responseBodyJSON;
    if ([result isKindOfClass:[NSDictionary class]]) {
        UserProfile *userProfile = [[UserProfile alloc] initWithDictionary:result error:nil];
        return userProfile;
    }

    return nil;
}

@end

//user menu
@implementation GetUserMenuRequest
- (NSString *)requestUrl {
    return kApiGetMenu;
}

- (id)requestParameters {
    return @{};
}

- (id)parseResult {
    id result = self.responseBodyJSON;
    if ([result isKindOfClass:[NSDictionary class]]) {
        UserMenu *userMenu = [[UserMenu alloc] initWithDictionary:result error:nil];
        return userMenu;
    }
    
    return nil;
}
@end

//GetUserNotifyTypeRequest
@implementation GetUserNotifyTypeRequest
- (NSString *)requestUrl {
    return kApiGetNotifyType;
}

- (id)requestParameters {
    return @{};
}

- (id)parseResult {
    //return (NSArray *)self.responseBodyJSON;
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSArray *list = (NSArray *)self.responseBodyJSON;
    for(int i = 0; i<list.count; i++){
        [data addObject:[[ClassNoticeType alloc] initWithDictionary:list[i] error:nil]];
    }
     
    return data;

}
@end

//GetChangePWDRequest
@implementation GetChangePWDRequest
- (NSString *)requestUrl {
    return kApiChangePWD;
}

- (id)requestParameters {
    return @{@"OldPassword":self.OldPassword?:[NSNull null],
             @"NewPassword":self.NewPassword?:[NSNull null]};
}

- (id)parseResult {
    id result = self.responseBodyJSON;
    return result;
}
@end

//logout
@implementation UserLogoutRequest
- (NSString *)requestUrl {
    return kApiExit;
}

- (id)requestParameters {
    return @{};
}

- (id)parseResult {
    id result = self.responseBodyJSON;
    return result;
}
@end

//headimage
@implementation UpdateUserHeadRequest
- (NSString *)requestUrl {
    return kApiUpdateHeadImg;
}

- (id)requestParameters {
    return @{@"HeadImg":self.HeadImg?:[NSNull null]};
}

- (id)parseResult {
    id result = self.responseBodyJSON;
    return result;
}

@end

//判断首页是否有未读消息
@implementation GetReadLogRequest
- (NSString *)requestUrl {
    return kApiGetReadLog;
}

- (id)requestParameters {
    return @{@"ClassName":self.ClassName?:[NSNull null]};
}

- (id)parseResult {
    id result = self.responseBodyJSON;
    return result;
}
@end
