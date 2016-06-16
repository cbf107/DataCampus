//
//  RelationshipTableViewCell.m
//  ZhiKu
//
//  Created by coreyfu on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "AddressBookCell.h"
#import "CommonRequest.h"
#import "BaseRequest.h"

@implementation AddressBookCell
- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.mInviteButton.layer.cornerRadius = 3.0f;
    self.mInviteButton.layer.masksToBounds = YES;
    
    self.mInviteButton.layer.borderColor = [UIColor colorWithHexString:@"c3c2c2"].CGColor;
    self.mInviteButton.layer.borderWidth = 1.0f;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setInfo:(TKAddressBook *)contact {
    _mContact = contact;
    [self.mNameLable setText:contact.name];
    
    if ([contact.status intValue] == 1) {
        [self.mInviteButton setTitle:@"邀请" forState:UIControlStateNormal];
    }else if([contact.status intValue] == 2) {
        [self.mInviteButton setTitle:@"添加" forState:UIControlStateNormal];
    }else if([contact.status intValue] == 3) {
        [self.mInviteButton setTitle:@"好友" forState:UIControlStateNormal];
    }
}

-(IBAction)sendInviteToFriend:(id)sender{
    NSLog(@"send invite %@", _mContact.tel);
    if ([_mContact.status intValue] == 1) {
        GetSMSCodeRequest *requester = [[GetSMSCodeRequest alloc] init];
        requester.mPhone = _mContact.tel;
        requester.mType = ESMSTypeInvitation;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        
        [requester startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
            NSLog(@"result = %@",[request responseBodyJSON]);
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:@"成功" message:@"发送成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];

        } failure:^(NSError *err) {
            [SVProgressHUD dismiss];
            
            [[[UIAlertView alloc] initWithTitle:@"失败" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];

    }else if([_mContact.status intValue] == 2) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        
        AddFriendsRequest *addRequest = [[AddFriendsRequest alloc]init];
        
        addRequest.mUserIds = _mContact.mUserIds;
        addRequest.mGroup = 1;
        
        [addRequest startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"添加好友成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        } failure:^(NSError *err) {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:@"添加好友失败" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];

    }else if([_mContact.status intValue] == 3) {
    }

}
@end
