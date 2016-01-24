//
//  ViewContainer.h
//  TakeCar
//
//  Created by coreyfu on 14-7-1.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//
#import "ExPageControl.h"

/* 通过xib加载时，用ViewContainer的tag标记初始化方式
 * 页码指示器为原点
 * tag == 0 :沿水平方向增加页，并且显示页码标记:pagecontrol
 * tag == 1 :沿水平方向增加页，并且不显示页码标记:分数形式：如1/3
 * tag == 2 :沿垂直方向增加页，并且不显示页码标记
 * tag == 3 :沿垂直方向增加页，并且显示页码标记
 * tag == 4 :引导页
 */
typedef enum _EContainerAddPageMode
{
    EContainerAddPageModeHorizontalShowIndicatorUseStylePageControl = 0,
    EContainerAddPageModeHorizontalShowIndicatorUseStyleFraction,
    EContainerAddPageModeHorizontalNoPageControl,
    EContainerAddPageModeVerticalNoPageControl,
    EContainerAddPageModeHorizontalShowIndicatorUseStylePageControlOnGuideStyle
}EContainerAddPageMode;

@class ViewContainer;
/*
 * 点击回调
 * @para item:添加到ViewContainer的视图
 * 即数据源itemAtIndex:返回的视图
 */
@protocol ViewContainerDelegate
@optional
- (void)itemDidClickedInView:(UIView *)item;
- (void)viewContainer:(ViewContainer *)container didScrollToPage:(NSInteger)page;
@end

/*
 * 数据源
 * 提供ViewContainer需要的数据
 * 方法均为可选，数值型数据默认为0
 */
@protocol ViewContainerDataSource
@optional
//需要加入的子视图数量
- (NSUInteger) numberOfItems:(ViewContainer *)container;
//对应子视图
- (UIView *)container:(ViewContainer *)container itemAtIndex:(NSInteger)index;
//容器四周边距
- (UIEdgeInsets)containerEdgeInsets;
//子视图水平间距
- (NSUInteger)xSpaceOfItem:(ViewContainer *)container;
//子视图垂直间距
- (NSUInteger)ySpaceOfItem:(ViewContainer *)container;

@end

@interface ViewContainer : UIView

@property (nonatomic,strong) UIImage *backgroundImage;//容器背景图
@property (nonatomic,weak) IBOutlet id<ViewContainerDelegate> delegate;//回调
@property (nonatomic,weak) IBOutlet id<ViewContainerDataSource> datasource;//数据源

@property (nonatomic,readonly) UIScrollView *scrollView;//容器背景图

//数据源变化后调用此方法重新加载子视图
- (float)reloadData;
- (void)reloadDataAtIndex:(NSInteger)index;
- (void)addSubItem:(UIView *)item;
- (void)insertItem:(UIView *)item atIndex:(NSInteger)index;

- (void)scrollToPage:(NSInteger)page;
/* 
 * 初始化方法
 * @para frame:容器大小
 * @para show:是否显示分页指示器
 * @para mode:子视图加入方式
 */
- (id)initWithFrame:(CGRect)frame
  showPageIndicator:(BOOL)show
           pageMode:(EContainerAddPageMode)mode;

@end
