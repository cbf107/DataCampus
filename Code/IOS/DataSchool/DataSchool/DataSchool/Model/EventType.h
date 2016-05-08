//
//  UserMenu.h
//  ZhiKu
//
//  Created by mac on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "JSONModel.h"

@protocol EventType
@end

@interface EventType : JSONModel
@property (nonatomic, copy)NSString *ItemName;
@end
