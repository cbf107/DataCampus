//
//  UserMenu.h
//  ZhiKu
//
//  Created by mac on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "JSONModel.h"

@protocol ClassNoticeType
@end

@interface ClassNoticeType : JSONModel
@property (nonatomic, copy)NSString *Type;
@end





@protocol ClassNotice
@end

@interface ClassNotice : JSONModel
@property (nonatomic, copy)NSString *RefId;
@property (nonatomic, copy)NSString *Title;
@property (nonatomic, copy)NSString *Content;
@property (nonatomic, copy)NSString *InsertTime;
@property (nonatomic, copy)NSString *Type;
@property (nonatomic, copy)NSString *Img;
@property (nonatomic, copy)NSString *Url;
@property (nonatomic, copy)NSString *CreateUserRefId;
@property (nonatomic, copy)NSString *IsRead;
@property (nonatomic, copy)NSString *ReadTime;
@property (nonatomic, copy)NSString *ClassRefid;
@property (nonatomic, copy)NSString *StatusUrl;

@end





@protocol ClassNotices
@end

@interface ClassNotices : JSONModel
@property (nonatomic, copy)NSArray<ClassNotice> *ClassNotices;

@end
