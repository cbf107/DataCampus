//
//  LoginVC.m
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "LoginVC.h"
#import "SysRequest.h"
#import "UserProfile.h"

@interface LoginVC ()
@property (nonatomic, weak) IBOutlet UIView *mMobileView;
@property (nonatomic, weak) IBOutlet UIView *mPwdView;

@property (nonatomic, weak) IBOutlet UITextField *mEditMobile;
@property (nonatomic, weak) IBOutlet UITextField *mEditPwd;

@property (nonatomic, weak) IBOutlet UIButton *mBtnLogin;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mMobileView.layer.cornerRadius = 5;
    _mMobileView.layer.masksToBounds = YES;
    
    _mPwdView.layer.cornerRadius = 5;
    _mPwdView.layer.masksToBounds = YES;
    
    _mBtnLogin.layer.cornerRadius = 5;
    _mBtnLogin.layer.masksToBounds = YES;
    
    _mEditMobile.text = @"";//@"18382429837";//@"18382329840";//18583625888
    _mEditPwd.text = @"";
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)login:(id)sender {
    if (_mEditMobile.text==nil || _mEditPwd.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"请输入账号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    } else if (_mEditPwd.text==nil || _mEditPwd.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    } else {
        UserLoginRequest *request = [[UserLoginRequest alloc]init];
        request.UserId = _mEditMobile.text;
        request.Password = _mEditPwd.text;
        request.MemberRefId = MemberRefID;
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
            [SVProgressHUD dismiss];
            
            UserInfo *userInfo = request.parseResult;
            if (userInfo != nil) {
                [UserManager loginSuccessWithUserInfo:userInfo];
            }
            //userInfo.sUserRefId = result[@"UserRefId"];
            //[UserManager currentUser].sUserRefId = result[@"UserRefId"];

            //regFinishFlow.mPassportLable.text = result[@"body"][@"sPassport"];
            //regFinishFlow.mCheckStatus = [result[@"body"][@"iCheck"] intValue];
            
            GetUserProfileRequest *getProfileRequest = [[GetUserProfileRequest alloc] init];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
            [getProfileRequest startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
                [SVProgressHUD dismiss];
                UserProfile *userProfile = request.parseResult;
                
                UserInfo *userInfo = [UserManager currentUser];
                userInfo.Icon = userProfile.UserImage;
                userInfo.UserType = userProfile.UserType;
                userInfo.UserGrade = userProfile.UserGrade;
                userInfo.UserName = userProfile.UserName;
                userInfo.UserNum = userProfile.UserNum;
                userInfo.UserClasses = userProfile.UserClasses;
                userInfo.UserQRURL = userProfile.UserQRCode;
                
                UserClass *userClass = userInfo.UserClasses[0];
                userInfo.CurrentUserClass = userClass.ClassName;
                
                if (userInfo != nil) {
                    [UserManager loginSuccessWithUserInfo:userInfo];
                }
                
                [APPDELEGATE launchToMainPage];
            } failure:^(NSError *err) {
                [SVProgressHUD dismiss];
                [[[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            }];
            
        } failure:^(NSError *err) {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
    }
        //[APPDELEGATE launchToMainPage];
    /*if (_mEditMobile.text==nil || ![_mEditMobile.text isMobileNumber]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    } else if (_mEditPwd.text==nil || _mEditPwd.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    } else {
        UserLoginRequest *request = [[UserLoginRequest alloc]init];
        request.sMobile = _mEditMobile.text;
        request.sCode = _mEditPwd.text;
        
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
            UserInfo *userInfo = request.parseResult;
            userInfo.iNewUser = _iNewUser;
            [UserManager loginSuccessWithUserInfo:userInfo];
            [SVProgressHUD dismiss];
            
            if (_iNewUser == 2) {
                [APPDELEGATE launchToMainPage];
            }else{
                [APPDELEGATE launchToReg];
            }
        } failure:^(NSError *err) {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:@"获取验证码失败" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
        
        //[APPDELEGATE launchToMainPage];
    }*/
}

@end
