//
//  InfiniteScrollContainer.h
//  ImageScrollTest
//
//  Created by coreyfu on 14-7-25.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfiniteScrollContainer;

//回调
@protocol InfiniteScrollContainerDelegate
@optional
/*
 * 点击回调函数.
 * @param scrollContainer 容器视图.
 * @param item 被点击视图.
 * @param itemIndex 被点击视图索引.
 */
- (void)infiniteScrollContainer:(InfiniteScrollContainer *)scrollContainer
                 didSelectItem:(UIView *)item atIndex:(NSInteger)itemIndex;
@end


//数据源
@protocol InfiniteScrollContainerDataSource
/*
 * @param scrollContainer 容器视图.
 * @param itemIndex 视图索引.
 */
- (UIView *)infiniteScrollContainer:(InfiniteScrollContainer *)scrollContainer
                           forIndex:(NSInteger)itemIndex;
/*
 * 子视图数量
 * @param scrollContainer 容器视图.
 */
- (NSUInteger)numberOfItemsInInfiniteScrollContainer:(InfiniteScrollContainer *)scrollContainer;

/*
 * 每个视图的宽度，一般传scrollContainer.frame.size.width
 * @param scrollContainer 容器视图.
 * @param itemIndex 视图索引.
 */
- (CGFloat)infiniteScrollContainer:(InfiniteScrollContainer *)scrollContainer
                     widthForIndex:(NSInteger)itemIndex;
@end

@interface InfiniteScrollContainer :UIScrollView

@property (nonatomic, getter = isCircular) BOOL circular;//是否循环滚动
@property (nonatomic, getter = isPaging) BOOL paging;//是否分页
@property (nonatomic,weak) IBOutlet id<InfiniteScrollContainerDelegate> delegateSC;
@property (nonatomic,weak) IBOutlet id<InfiniteScrollContainerDataSource> dataSource;

//获取重用视图
- (id)dequeueReusableItem;

//数据源有更新后重新加载
- (void)reloadData;

//重新开始滚动，
- (void)resume;

//当视图处于非活动状态时，需要暂停
- (void)pause;

@end
