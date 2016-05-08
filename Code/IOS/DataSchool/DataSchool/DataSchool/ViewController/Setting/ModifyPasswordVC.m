//
//  ModifyPasswordViewController.m
//  MarketEleven
//
//  Created by Bergren Lam on 8/25/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import "ModifyPasswordVC.h"
#import "GNKeyboardUtil.h"
#import "ImageManager.h"
#import "GNUtil.h"
#import "SysRequest.h"

@interface ModifyPasswordVC () <UITextFieldDelegate,UIAlertViewDelegate>

- (IBAction)onTap:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *field1;
@property (weak, nonatomic) IBOutlet UITextField *field2;
@property (weak, nonatomic) IBOutlet UITextField *field3;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation ModifyPasswordVC

-(void)dealloc {
    [GNKeyboardUtil removeKeyboradObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    
    
    [GNKeyboardUtil addKeyboardObserverForAdjustView:self.tableView];
    
    
}

-(void)commonInit {
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    self.tableView.allowsSelection = NO;
    
    /*[self.confirmBtn setBackgroundImage:[ImageManager imageOfType:EImageButtonRedN] forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundImage:[ImageManager imageOfType:EImageLoginHighlight] forState:UIControlStateHighlighted];*/
    self.confirmBtn.layer.cornerRadius = 4;
    [self.confirmBtn setBackgroundColor:[UIColor colorWithHexString:kAppColorNavBkg]];
    self.field1.keyboardType = UIKeyboardTypeASCIICapable;
    self.field2.keyboardType = UIKeyboardTypeASCIICapable;
    self.field3.keyboardType = UIKeyboardTypeASCIICapable;

    [self.field1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.field2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.field3 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}

- (void)textFieldDidChange:(UITextField *)textField
{
    NSInteger payMaxLength = 16;
    
    NSString *text = textField.text;
    
    if (text.length > payMaxLength) {
        textField.text = [text substringToIndex:payMaxLength];
    }
}

- (BOOL)checkInformation
{
    
    if ([self.field1.text length] == 0) {
        [self.field1 shake];
        return NO;
    }
    
    if ([self.field2.text length] == 0) {
        [self.field2 shake];
        return NO;
    }
    
    if ([self.field2.text length] < 4) {
        [self.field2 shake];
        [UIAlertView showWithTitle:@"提示" message:@"输入密码过短"];
        return NO;
    }
    
    if ([self.field2.text length] > 16) {
        [self.field2 shake];
        [UIAlertView showWithTitle:@"提示" message:@"输入密码应小于16位"];
        return NO;
    }
    
    if ([self.field3.text length] == 0) {
        [self.field3 shake];
        return NO;
    }
    
    if (![self.field2.text isEqualToString:self.field3.text]) {
        [self.field3 shake];
        return NO;
    }
    
    return YES;
}

- (IBAction)onConfirm:(UIButton *)sender
{
    if (![self.field2.text isEqualToString:self.field3.text]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"新密码两次输入不匹配" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    
    GetChangePWDRequest *request = [[GetChangePWDRequest alloc] init];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    request.OldPassword = self.field1.text;
    request.NewPassword = self.field2.text;
    
    [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码更新成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [SVProgressHUD dismiss];

        alert.tag = 1;
        
        [alert show];

    }failure:^(NSError *err) {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码更新失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag = 1;
        
        [alert show];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 15;
    }
    return 12;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if ([string isEqualToString:@" "] || [string isEqualToString:@"\n"]) {
        return NO;
    }
    
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }

    /*[UserManager logOut:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationModifyPasswordSuccess" object:nil];
    }];*/
}

@end
