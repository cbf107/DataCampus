//
//  CleanRequest.m
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "SchoolNewsRequest.h"
#import "SchoolNews.h"

@implementation GetSchoolNewsCover
- (NSString *)requestUrl {
    return kApiGetShoolNewsCover;
}

- (id)requestParameters {
    return @{};
}

- (id)parseResult {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSArray *list = (NSArray *)self.responseBodyJSON;
    for(int i = 0; i<list.count; i++){
        [data addObject:[[School_News alloc] initWithDictionary:list[i] error:nil]];
    }
    
    return data;

}
@end

@implementation GetSchoolNews
- (NSString *)requestUrl {
    return kApiGetShoolNews;
}

- (id)requestParameters {
    //return @{};
    return @{@"start":@(self.pageStart),
             @"length":@(self.pageLength)};

}

- (id)parseResult {
    /*id result = self.responseBodyJSON;
    if ([result isKindOfClass:[NSDictionary class]]) {
        School_Newss *schoolNewss = [[School_Newss alloc] initWithDictionary:result error:nil];
        return schoolNewss;
    }
    
    return nil;*/
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSArray *list = (NSArray *)self.responseBodyJSON;
    for(int i = 0; i<list.count; i++){
        [data addObject:[[School_News alloc] initWithDictionary:list[i] error:nil]];
    }
    
    return data;

}
@end
