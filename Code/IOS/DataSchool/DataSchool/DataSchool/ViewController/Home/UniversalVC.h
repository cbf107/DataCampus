//
//  LoginVC.h
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UniversalVC : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *mContentWebView;
@property (nonatomic, copy)NSString *mURL;

@property (nonatomic, assign)int iType;// 0 - 通用型， 1 - 班主任
@property (nonatomic, copy)NSString *mPhone;//班主任的时候需要

@end
