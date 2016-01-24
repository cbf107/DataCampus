//
//  MessageInfo.h
//  ZhiKu
//
//  Created by mac on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "JSONModel.h"


//新闻界面banner封面数组
@protocol School_News
@end

@interface School_News : JSONModel
@property (nonatomic, copy)NSString *RefId;
@property (nonatomic, copy)NSString *Title;
@property (nonatomic, copy)NSString *Content;
@property (nonatomic, copy)NSString *InsertTime;
@property (nonatomic, copy)NSString *Cover;

@property (nonatomic, copy)NSString *CreateUserRefid;
@property (nonatomic, copy)NSString *AudioRefid;
@property (nonatomic, assign)int IsReply;
@property (nonatomic, assign)int IsAuto;

@property (nonatomic, copy)NSString *PublicTime;
@property (nonatomic, assign)int State;
@property (nonatomic, copy)NSString *AuditTime;
@property (nonatomic, copy)NSString *Audit;
@property (nonatomic, copy)NSString *Url;
@property (nonatomic, assign)int Sort;

@end


@protocol School_Newss
@end

@interface School_Newss : JSONModel
@property (nonatomic, copy)NSArray<School_News> *School_Newss;
@end

