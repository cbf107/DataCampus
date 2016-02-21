//
//  LoginVC.m
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "SettingWebVC.h"
#import "SysRequest.h"

@implementation SettingWebVC
@synthesize sTitle = _sTitle;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [_mContentWebView setDelegate:self];
    
    NSURL *url = [NSURL URLWithString:_sURL];
    
    [self.mContentWebView loadRequest:[NSURLRequest requestWithURL:url]];
    self.title = _sTitle;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
}

//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

//数据加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    [SVProgressHUD dismiss];
     [[[UIAlertView alloc] initWithTitle:@"错误" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}


@end
