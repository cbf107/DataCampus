//
//  LoginVC.m
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "DetailInfoVC.h"
#import "SysRequest.h"
#import "UniversalVC.h"

@implementation DetailInfoVC
@synthesize sURL = _sURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _mTitle;
    UserInfo *info = [UserManager currentUser];
    
    if ([info.UserType isEqualToString:@"教师"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看" style:UIBarButtonItemStyleBordered target:self action:@selector(checkIsRead)];
    }

    // Do any additional setup after loading the view.
    [_mContentWebView setDelegate:self];
    
    //NSURL *url = [NSURL URLWithString:@"http://115.28.85.127:8084/wdpm/agreement.html"];
    
    [self.mContentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_sURL]]];
}

-(void)checkIsRead{
    UniversalVC *universal = (UniversalVC *)[UIViewController viewControllerWithStoryboard:@"Universal" identifier:@"UniversalVC"];
    
    universal.mURL = _mStatusUrl;
    universal.title = @"查看状态";
    
    [self.navigationController pushViewController:universal animated:YES];

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
