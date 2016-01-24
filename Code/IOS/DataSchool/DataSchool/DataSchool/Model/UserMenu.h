//
//  UserMenu.h
//  ZhiKu
//
//  Created by mac on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "JSONModel.h"

@protocol Menu
@end

@interface Menu : JSONModel
@property (nonatomic, copy)NSString *MenuRefId;
@property (nonatomic, copy)NSString *MenuName;
@property (nonatomic, copy)NSString *MenuType;
@property (nonatomic, copy)NSString *MenuFunction;
@property (nonatomic, copy)NSString *CurrentVersion;
@end


@protocol UserMenu
@end

@interface UserMenu : JSONModel
@property (nonatomic, copy)NSArray<Menu> *Menus;

@end
