//
//  LoginVC.h
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingWebVC : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *mContentWebView;
@property (nonatomic, copy) NSString *sTitle;
@property (nonatomic, copy) NSString *sURL;

@end
