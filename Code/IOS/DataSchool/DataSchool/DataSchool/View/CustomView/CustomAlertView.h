//
//  CustomAlertView.h
//  EasyParking
//
//  Created by wuxin on 15/4/30.
//  Copyright (c) 2015年 meineke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomAlertViewDelegate <NSObject>

- (void)clickAlertButton:(NSInteger)index;

@end

@interface CustomAlertView : UIView

@property (assign, nonatomic) id<CustomAlertViewDelegate> delegate;

+ (CustomAlertView *)AlertView;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

- (void)show;

- (void)dismiss;

@end
