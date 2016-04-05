//
//  CleanRequest.h
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

//获取学校新闻banner图片
@interface SendNoticeRequest : BaseRequest
@property(nonatomic, copy)NSString *Title;
@property(nonatomic, copy)NSString *Content;
@property(nonatomic, copy)NSArray *ClassName;
@property(nonatomic, copy)NSString *Type;
@property(nonatomic, copy)NSArray  *Imgs;//话题对应图片,格式：[“xxxx”,“xxxx”,“xxxx”}]格式为二进制base64编码串(格式：data:image/jpg;base64,二进制base64编码)
@property(nonatomic, copy)NSString *CreateUserRefid;
@end

//获取学校新闻
@interface GetClassNoticeRequest : BaseRequest
@property(nonatomic, copy)NSString *Type;
@property (nonatomic, copy)NSString *className;
@end

//删除消息
@interface DeleteNoticeRequest : BaseRequest
@property(nonatomic, copy)NSString *NoticeRefId;
@end
