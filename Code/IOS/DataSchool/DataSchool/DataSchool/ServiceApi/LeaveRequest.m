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
    return kApiLeaveTeacher;
}

- (id)requestParameters {
    return @{};
    
}

- (id)parseResult {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    id result = self.responseBodyJSON;
    NSArray *list = (NSArray *)result[@"Teachers"];
    for(int i = 0; i<list.count; i++){
        [data addObject:[[LeaveTeacher alloc] initWithDictionary:list[i] error:nil]];
    }
    
    return data;
}
@end

@implementation LeaveHistoryRequest
- (NSString *)requestUrl {
    return kApiLeaveHistory;
}

- (id)requestParameters {
    return @{};
    
}

- (id)parseResult {
    return self.responseBodyJSON;
}
@end


@implementation LeaveSubmitRequest
- (NSString *)requestUrl {
    return kApiLeaveSubmit;
}

- (id)requestParameters {
    return @{@"Content":self.Content?:[NSNull null],
             @"Type":self.Type?:[NSNull null],
             @"Imgs":[self makeImages],
             @"StartDateTime":self.StartDateTime?:[NSNull null],
             @"EndDateTime":self.EndDateTime?:[NSNull null],
             @"AttendanceCount":self.AttendanceCount?:[NSNull null],
             @"Works":self.Works?:[NSNull null]};
    
}

- (id)makeImages {
    if (nil != self.Imgs) {
        switch (self.Imgs.count) {
            case 0:
                return @[];
            case 1:
                return @[self.Imgs[0]];
            case 2:
                return @[self.Imgs[0],self.Imgs[1]];
            case 3:
                return @[self.Imgs[0],self.Imgs[1],self.Imgs[2]];
                
            default:
                break;
        }
    }
    return [NSNull null];
}

- (id)parseResult {
    return self.responseBodyJSON;
}
@end
