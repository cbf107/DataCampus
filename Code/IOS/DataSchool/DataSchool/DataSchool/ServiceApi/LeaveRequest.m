//
//  CleanRequest.m
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "LeaveRequest.h"
#import "ClassNotice.h"
#import "LeaveInfo.h"

@implementation LeaveTypeRequest
- (NSString *)requestUrl {
    return kApiLeaveType;
}

- (id)requestParameters {
    return @{};

}

- (id)parseResult {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSArray *list = (NSArray *)self.responseBodyJSON;
    for(int i = 0; i<list.count; i++){
        [data addObject:[[LeaveType alloc] initWithDictionary:list[i] error:nil]];
    }
    
    return data;
}
@end


@implementation LeaveWorkRequest
- (NSString *)requestUrl {
    return kApiLeaveWork;
}

- (id)requestParameters {
    return @{};
    
}

- (id)parseResult {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSArray *list = (NSArray *)self.responseBodyJSON;
    for(int i = 0; i<list.count; i++){
        [data addObject:[[LeaveType alloc] initWithDictionary:list[i] error:nil]];
    }
    
    return data;
}
@end


@implementation LeaveTeacherRequest
- (NSString *)requestUrl {
    return nil;
}

- (id)requestParameters {
    return @{};
    
}

- (id)parseResult {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSArray *list = (NSArray *)self.responseBodyJSON;
    for(int i = 0; i<list.count; i++){
        [data addObject:[[LeaveType alloc] initWithDictionary:list[i] error:nil]];
    }
    
    return data;
}
@end