//
//  RefreshTableView.h
//  MarketEleven
//
//  Created by Bergren Lam on 1/8/15.
//  Copyright (c) 2015 Meinekechina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRequest.h"

typedef enum {
    RefreshTableViewStatusNormal,  //正常
    RefreshTableViewStatusNoResult,   //无数据
    RefreshTableViewStatusNoNetwork, //无网络
    RefreshTableViewStatusLoadError
}RefreshTableViewStatus;

@interface RefreshTableView : UITableView

@property (nonatomic, strong)BaseRequest *request;
@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, copy)void (^refreshStatusViewBlock)(RefreshTableViewStatus status);

- (void)addHeader;
- (void)addFooter;


@property (nonatomic, assign)BOOL needHeader; //default is yes
@property (nonatomic, assign)BOOL needFooter; //default is yes

//用下拉上拉加载方式
- (void)headerRereshing;
- (void)footerRereshing;

- (void)begainLoadData;//用模态加载方式
@end


@interface RefreshStatusView : UIView

- (RefreshStatusView *)initWithImageName:(NSString *)name text:(NSString *)text;

+ (RefreshStatusView *)statusViewWithStatus:(RefreshTableViewStatus)status;


@end
