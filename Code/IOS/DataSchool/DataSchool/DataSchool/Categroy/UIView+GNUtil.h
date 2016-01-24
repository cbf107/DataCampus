//
//  UIView+GNHelper.h
//  citytime
//
//  Created by mac on 14-3-10.
//  Copyright (c) 2014年 wonler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GNUtil)

//以tree形式输出view的层级关系
+ (NSString *) displayViews: (UIView *) aView;

- (void)replaceConstraint:(NSLayoutAttribute)attribute1
              onFirstItem:(id)view1
            andConstraint:(NSLayoutAttribute)attribute2
             onSecondItem:(id)view2
             withConstant:(float)constant;

- (void)resetHeightConstraint:(CGFloat)height;
- (void)resetWdithConstraint:(CGFloat)width;

-(UIViewController*)getParentVC;

@property(nonatomic, readonly)CGFloat x;
@property(nonatomic, readonly)CGFloat y;
@property(nonatomic, readonly)CGFloat width;
@property(nonatomic, readonly)CGFloat height;
@property(nonatomic, readonly)CGFloat right;
@property(nonatomic, readonly)CGFloat bottom;
@end
