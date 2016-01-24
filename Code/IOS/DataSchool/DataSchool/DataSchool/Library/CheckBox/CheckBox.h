//
//  CheckBox.m
//  ZhiKu
//
//  Created by Bergren Lam on 15/5/24.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckBoxDelegate;

@interface CheckBox:UIView

@property (nonatomic, retain)NSString *text;
@property (nonatomic, assign)BOOL checked;

@property (nonatomic, retain)id<CheckBoxDelegate> delegate;

-(id)initWithText:(NSString *)text frame:(CGRect)frame imageType:(int)type;

@end

@protocol CheckBoxDelegate <NSObject>

-(void)onChangeDelegate:(CheckBox *)checkbox isCheck:(BOOL)isCheck;

@end