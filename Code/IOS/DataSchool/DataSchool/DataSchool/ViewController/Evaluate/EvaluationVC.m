//
//  LoginVC.m
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "EvaluationVC.h"
#import "SysRequest.h"
#import "IIViewDeckController.h"

@interface EvaluationVC ()
@end

@implementation EvaluationVC
@synthesize mURL = _mURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"扫描" style:UIBarButtonItemStyleBordered target:self action:@selector(setupCamera)];


    // Do any additional setup after loading the view.
    [_mContentWebView setDelegate:self];
    
    NSURL *url = [NSURL URLWithString:_mURL];
    
    [self.mContentWebView loadRequest:[NSURLRequest requestWithURL:url]];

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
}


//scan code
-(void)setupCamera{
    ScanViewController * scanVC = [[ScanViewController alloc]init];
    //[self presentViewController:scanVC animated:YES completion:^{
    //}];
    scanVC.passDelegate = self;
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:scanVC];
    
    [self presentViewController:navController animated:YES completion:^{
    }];

}

//PassValueDelegate
- (void)passValue:(NSString *)studentNum{
    UserInfo *info = [UserManager currentUser];
    NSString *value = [NSString stringWithFormat:@"%@?SutdentNum=%@&MemberRefId=%@", _mURL, studentNum, info.MemberRefId];
    NSURL *url = [NSURL URLWithString:value];
    
    [self.mContentWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
}


@end
