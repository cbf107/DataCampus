//
//  LoginVC.h
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailInfoVC : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *mContentWebView;
@property (nonatomic, copy)NSString *sURL;
@property (nonatomic, copy)NSString *mStatusUrl;
@end
