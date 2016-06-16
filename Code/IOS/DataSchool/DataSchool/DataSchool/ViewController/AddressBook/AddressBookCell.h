//
//  RelationshipTableViewCell.h
//  ZhiKu
//
//  Created by coreyfu on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKAddressBook.h"

@interface AddressBookCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *mNameLable;
@property (nonatomic, weak) IBOutlet UIButton *mInviteButton;
@property (nonatomic, strong)TKAddressBook *mContact;

@property(nonatomic, strong)NSIndexPath *mIndexPath;

- (void)setInfo:(TKAddressBook *)contact;

@end
