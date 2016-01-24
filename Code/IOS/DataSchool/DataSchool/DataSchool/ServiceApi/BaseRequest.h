//
//  BaseRequest.h
//  MarketEleven
//
//  Created by Bergren Lam on 11/20/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import "YTKRequest.h"


@protocol PagingViewController;


@interface BaseRequest : YTKRequest

- (instancetype)initWithStart:(NSInteger)start length:(NSInteger)length;
@property (nonatomic, assign)NSInteger pageStart;//页数	Integer	1
@property (nonatomic, assign)NSInteger pageLength;//	每页行数	Integer	15



- (NSDictionary *)pageParameter;

- (void)startWithCompletionBlockWithSuccess:(void (^)(BaseRequest *request))success
                                    failure:(void (^)(NSError *err))failure;


+ (void(^)(void))blockWithRequest:(BaseRequest *)request delegateController:(id<PagingViewController>)controller;


//设置下拉标记
- (void)setPullDownFlag:(BOOL)pullDown;
//下拉标记
- (BOOL)pullDownFlag;

@end



@protocol PagingViewController <NSObject>

- (UITableView *)tableView;

- (NSMutableArray *)dataArray;

@end
