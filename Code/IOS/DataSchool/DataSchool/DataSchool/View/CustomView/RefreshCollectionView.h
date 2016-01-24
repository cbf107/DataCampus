//
//  RefreshCollectionView.h
//  MarketEleven
//
//  Created by Bergren Lam on 1/8/15.
//  Copyright (c) 2015 Meinekechina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRequest.h"

/*typedef enum {
    RefreshCollectionViewStatusNormal,  //正常
    RefreshCollectionViewStatusNoResult,   //无数据
    RefreshCollectionViewStatusNoNetwork, //无网络
    RefreshCollectionViewStatusLoadError
}RefreshCollectionViewStatus;*/

@interface RefreshCollectionView : UICollectionView

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


/*@interface RefreshCollectionStatusView : UIView

- (RefreshCollectionViewStatus *)initWithCollectionImageName:(NSString *)name text:(NSString *)text;

+ (RefreshCollectionViewStatus *)statusCollectionViewWithStatus:(RefreshTableViewStatus)status;


@end*/
