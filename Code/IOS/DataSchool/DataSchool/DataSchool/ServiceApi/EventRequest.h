//
//  CleanRequest.h
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventSendRequest : BaseRequest
@property(nonatomic, copy)NSString *Content;
@property(nonatomic, copy)NSString *Type;
@property(nonatomic, copy)NSArray  *Imgs;//话题对应图片,格式：[“xxxx”,“xxxx”,“xxxx”}]格式为二进制base64编码串(格式：data:image/jpg;base64,二进制base64编码)
@property(nonatomic, copy)NSString *CreateUserRefid;
@end

////获取报修报事类型
@interface GetEventTypeRequest : BaseRequest
@end

//获取报事报修历史记录
@interface GetEventHistory : BaseRequest
@end