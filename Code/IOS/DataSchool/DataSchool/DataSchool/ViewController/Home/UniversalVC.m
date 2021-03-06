//
//  LoginVC.m
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "UniversalVC.h"
#import "SysRequest.h"
#import "IIViewDeckController.h"
#import "ScanViewController.h"


@implementation UniversalVC
@synthesize mURL = _mURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_iType == 1) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"电话联系" style:UIBarButtonItemStyleBordered target:self action:@selector(phoneAction)];
    }

    NSString *strURL;
    if(_iType == 2){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
        
        strURL = [NSString stringWithFormat:@"%@", _mURL];
    }else{
        strURL = [NSString stringWithFormat:@"%@%@", kServerAddressTest,_mURL];

    }

    // Do any additional setup after loading the view.
    [_mContentWebView setDelegate:self];
    
    //NSString *strURL = [NSString stringWithFormat:@"%@%@", kServerAddressTest,_mURL];
    //NSString *strURL = [NSString stringWithFormat:@"%@", _mURL];
    NSURL *url = [NSURL URLWithString:strURL];
    [self.mContentWebView loadRequest:[NSURLRequest requestWithURL:url]];

}

- (void)phoneAction {
    UIWebView *callWebview = [[UIWebView alloc] init];
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@", _mPhone];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telUrl]]];
    [self.view addSubview:callWebview];

    NSLog(@"phone = %@", _mPhone);
    //mPhone
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

@end
