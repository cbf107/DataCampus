//
//  ExamineView.m
//  EasyParking
//
//  Created by wuxin on 15/5/8.
//  Copyright (c) 2015年 meineke. All rights reserved.
//

#import "ExamineView.h"

@implementation ExamineView

+ (ExamineView *)shareExamineView{
    static ExamineView *examineView = nil;
    static dispatch_once_t examine;
    dispatch_once(&examine, ^{
        examineView = [[ExamineView alloc]init];
    });
    return examineView;
}


- (void)loadUI{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    _width = [[UIScreen mainScreen] bounds].size.width;
    _height = [[UIScreen mainScreen] bounds].size.height;
    
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = 0.5;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self.backgroundView addGestureRecognizer:tap];
    [window addSubview:self.backgroundView];
    
    self.exView = [[UIView alloc]initWithFrame:CGRectMake(22, 83, _width - 44, 406)];
    self.exView.backgroundColor = [UIColor whiteColor];
    self.exView.layer.cornerRadius = 5;
    self.exView.layer.masksToBounds = YES;
    [window addSubview:self.exView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(GetWidth(self.exView)/2-117/2, 18, 117, 80)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"park_update_icon"];
    [self.exView addSubview:imageView];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(GetWidth(self.exView)-25-5, 5, 25, 25);
    [cancel setBackgroundImage:[UIImage imageNamed:@"register_delete_icon"] forState:UIControlStateNormal];
//    [cancel setImage:[UIImage imageNamed:@"register_delete_icon"] forState:UIControlStateNormal];
//    cancel.contentMode = UIViewContentModeScaleAspectFit;
    [cancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.exView addSubview:cancel];
    
    UITextView *content = [[UITextView alloc]initWithFrame:CGRectMake(12, GetMax_Y(imageView)+21, GetWidth(self.exView)-24, GetHeight(self.exView)-GetHeight(imageView)-39)];
    content.userInteractionEnabled = NO;
    content.textColor = [UIColor colorWithHexString:@"333333"];
    content.font = [UIFont systemFontOfSize:14];
    content.text = self.text;
    [self.exView addSubview:content];
}

- (void)show{
    [self loadUI];
}

- (void)dismiss{
    [self.backgroundView removeFromSuperview];
    [self.exView removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
