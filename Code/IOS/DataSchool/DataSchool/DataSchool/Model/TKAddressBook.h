//
//  Personal.h
//  ZhiKu
//
//  Created by mac on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "JSONModel.h"

@protocol TKAddressBook
@end

@interface TKAddressBook : JSONModel
@property (nonatomic, assign) NSInteger sectionNumber;
@property (nonatomic, assign) NSInteger recordID;
@property (nonatomic, copy)   NSString *mUserIds;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *tel;
@property (nonatomic, retain) NSString *status;//1：这个人没有在我们的后台注册过
                                               //2：这个人再我们后台注册过，但是目前还不是我的好友
                                               //3：这个人再我们后台注册过，并且已经是我的好友

@end


@protocol TKAddressBooks
@end

@interface TKAddressBooks : JSONModel
@property (nonatomic, retain) NSArray<TKAddressBook> *contacts;
@end