//
//  CustomAlertView.m
//  EasyParking
//
//  Created by wuxin on 15/4/30.
//  Copyright (c) 2015年 meineke. All rights reserved.
//

#import "CustomAlertView.h"

@interface CustomAlertView(){
    CGFloat _width;
    CGFloat _height;
}
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSString *otherButtonTitle;
//@property (nonatomic, assign) id delegate;
@end

@implementation CustomAlertView

+ (CustomAlertView *)AlertView{
    CustomAlertView *alerView = nil;
    if (!alerView) {
        alerView = [[CustomAlertView alloc]init];
    }
    return alerView;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles{
    self = [super init];
    if (self) {
        self.title = title;
        self.message = message;
        self.delegate = delegate;
        self.otherButtonTitle = otherButtonTitles;
        self.cancelButtonTitle = cancelButtonTitle;
    }
    return self;
}

- (void)loadUI{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    _width = [[UIScreen mainScreen] bounds].size.width;
    _height = [[UIScreen mainScreen] bounds].size.height;
    
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = 0.5;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    [self.backgroundView addGestureRecognizer:tap];
    [window addSubview:self.backgroundView];

    self.alertView = [[UIView alloc]init];
    self.alertView.frame = CGRectMake(20, _height/2-149/2, _width-40, 149);
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.layer.borderWidth = 0.7;
    self.alertView.layer.cornerRadius = 5;
    self.alertView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.alertView.layer.shadowOffset = CGSizeMake(5.0f, -5.0f);
    self.alertView.layer.shadowOpacity = 0.9f;
    self.alertView.layer.masksToBounds =YES;
    self.alertView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [window addSubview:self.alertView];
    
    UILabel *title = [[UILabel alloc]init];
    title.frame = CGRectMake(0, 15, GetWidth(self.alertView), 25);
    title.text = @"提示";//self.title
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:16];
    title.textColor = [UIColor colorWithHexString:KAppFontColorTitle];
    [self.alertView addSubview:title];
    
    UITextView *message = [[UITextView alloc]init];
    message.frame = CGRectMake(12, GetMax_Y(title), GetWidth(self.alertView)-24, 40);
    message.userInteractionEnabled = NO;
    message.font = [UIFont systemFontOfSize:12];
    message.text = @"如在停放时段被交警贴条，请在个人中心停车记录中上传罚单照片，获取赔付。";//self.message
    message.textColor = [UIColor colorWithHexString:kAppFontColor];
    [self.alertView addSubview:message];
    
    //分割线1
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, GetMax_Y(message)+24, GetWidth(self.alertView), 1)];
    lineView1.backgroundColor = [UIColor colorWithHexString:kAppFontLineColorGray];
    [self.alertView addSubview:lineView1];
    
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.showsTouchWhenHighlighted = YES;
    cancelButton.frame = CGRectMake(0,
                                    GetMax_Y(message)+25,
                                    GetWidth(self.alertView)/2,
                                    44);
    [cancelButton setTitle:@"确定" forState:UIControlStateNormal];//self.cancelButton
    cancelButton.tag = 0;
    [cancelButton setTitleColor:[UIColor colorWithHexString
                               :KAppFontColorTitle] forState
                               :UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [cancelButton addTarget:self action
                           :@selector(clickButton:) forControlEvents
                          :UIControlEventTouchUpInside];
    [self.alertView addSubview:cancelButton];
    
    //分割线2
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(GetMax_X(cancelButton), GetMax_Y(message)+25, 1, GetHeight(cancelButton))];
    lineView2.backgroundColor = [UIColor colorWithHexString:kAppFontLineColorGray];
    [self.alertView addSubview:lineView2];
    
    //其他按钮
    UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    otherButton.showsTouchWhenHighlighted = YES;
    otherButton.frame = CGRectMake(GetMax_X(cancelButton),
                                   GetMax_Y(message)+25,
                                   GetWidth(self.alertView)/2,
                                   44);
    [otherButton setTitle:@"取消" forState:UIControlStateNormal];//self.otherButton
     otherButton.tag = 1;
    [otherButton setTitleColor:[UIColor colorWithHexString
                              :KAppFontColorTitle] forState
                              :UIControlStateNormal];
    otherButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [otherButton addTarget:self action
                          :@selector(clickButton:) forControlEvents
                          :UIControlEventTouchUpInside];
    [self.alertView addSubview:otherButton];
}

- (void)clickButton:(UIButton *)button{
    [self.delegate clickAlertButton:button.tag];
    [self dismiss];
}

- (void)removeView{
    [self dismiss];
}

- (void)show{
    [self loadUI];
}

- (void)dismiss{
    [self.backgroundView removeFromSuperview];
    [self.alertView removeFromSuperview];
}

@end
