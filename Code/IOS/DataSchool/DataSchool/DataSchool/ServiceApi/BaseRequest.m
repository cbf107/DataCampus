//
//  BaseRequest.m
//  MarketEleven
//
//  Created by Bergren Lam on 11/20/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//
#import <AdSupport/AdSupport.h>
#import "BaseRequest.h"
#import "UserManager.h"
#import "RequestPkgHead.h"

@implementation BaseRequest

- (instancetype)initWithStart:(NSInteger)start length:(NSInteger)length {
    if (self = [super init]) {
        self.pageStart = start;
        self.pageLength = length;
    }
    return self;
}

- (id)requestArgument{
    // lewis
//    UserInfo *user = [UserManager currentUser];
//    
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    BOOL sIsLogin = [UserManager isLogin];
//    return @{
//             @"ClientType":@(5),  // 3:Android   4:Android Pad    5:iPhone    6:iPad Pad
//             @"ClientSID":[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],//设备标识
//             @"UserPid":(sIsLogin?user.iUser:@""), //用户pid
//             @"UserToken":(sIsLogin?user.UserToken:@""), //用户token
//             @"ClientVersion":version
//             };
    id head = @{@"MemberRefId":[UserManager isLogin]?[UserManager currentUser].MemberRefId:@"",
                @"UserId":[UserManager isLogin]?[UserManager currentUser].UserId:@"",
                @"UserRefId":[UserManager isLogin]?[UserManager currentUser].UserRefId:@""};
    
    
    
    // 参数组装
    id param = @{@"head":head,
                 @"body":self.requestParameters};
    
    NSLog(@"请求参数:%@\n", [NSString jsonStringWithDictionary:param]);
    
    return param;
}

- (NSDictionary *)pageParameter {
    return @{@"start":@(self.pageStart), @"length":@(self.pageLength)};
}

- (void)startWithCompletionBlockWithSuccess:(void (^)(BaseRequest *))success failure:(void (^)(NSError *))failure {
    void (^block)(YTKBaseRequest *) = (void (^)(YTKBaseRequest *))success;
    [super startWithCompletionBlockWithSuccess:block failure:failure];
}



+ (void(^)(void))blockWithRequest:(BaseRequest *)request delegateController:(id<PagingViewController>)controller{
    __weak id<PagingViewController> weak = controller;
    
    void (^block)() = ^(){
        if (!request.pullDownFlag) {
            //request.page = weak.dataArray.count/request.rows + 1;
            request.pageStart = weak.dataArray.count/request.pageLength + 1;
            //request.pageStart = weak.dataArray.count;

        }
        
        
        [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
            if (request.pullDownFlag) {
                [weak.dataArray removeAllObjects];
                [weak.tableView headerEndRefreshing];
            }else {
                [weak.tableView footerEndRefreshing];
            }
            
            NSArray *arr = request.responseObject;
            if (arr.count < kPageCount) {
                [weak.tableView removeFooter];
            }
            [weak.dataArray addObjectsFromArray:arr];
            [weak.tableView reloadData];
            
            
        } failure:^(NSError *err) {
            if (request.pullDownFlag) {
                [weak.dataArray removeAllObjects];
                [weak.tableView headerEndRefreshing];
            }else {
                [weak.tableView footerEndRefreshing];
            }
        }];
        
    };
    return block;
}


- (void)setPullDownFlag:(BOOL)pullDown {
    self.userInfo = @{@"PullDownFlag":@(pullDown)};
}

- (BOOL)pullDownFlag {
    return [self.userInfo[@"PullDownFlag"] boolValue];
}

@end
