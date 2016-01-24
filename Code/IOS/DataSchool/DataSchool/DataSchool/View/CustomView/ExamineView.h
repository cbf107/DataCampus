//
//  ExamineView.h
//  EasyParking
//
//  Created by wuxin on 15/5/8.
//  Copyright (c) 2015年 meineke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamineView : UIView{
    CGFloat _width;
    CGFloat _height;
}
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *exView;
@property (nonatomic, strong) NSString *text;
+ (ExamineView *)shareExamineView;

- (void)show;
@end
