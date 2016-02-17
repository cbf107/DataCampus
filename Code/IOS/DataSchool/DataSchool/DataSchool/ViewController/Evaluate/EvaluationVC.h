//
//  LoginVC.h
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanViewController.h"

@interface EvaluationVC : UIViewController<UIWebViewDelegate, PassValueDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *mContentWebView;
@property (nonatomic, strong) UIImageView * line;
@property (nonatomic, copy)NSString *mURL;

@end
