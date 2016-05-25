//
//  CleanRequest.h
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaveTypeRequest : BaseRequest
@end

@interface LeaveWorkRequest : BaseRequest
@end

@interface LeaveTeacherRequest : BaseRequest
@end

@interface LeaveHistoryRequest:BaseRequest
@end

@interface LeaveSubmitRequest:BaseRequest
@property(nonatomic, copy)NSString *Content;//请假内容
@property(nonatomic, copy)NSString *Type;//请假类型
@property(nonatomic, copy)NSArray  *Imgs;//请假图片,格式：[“xxxx”,“xxxx”,“xxxx”}]格式为二进制base64编码串(格式：data:image/jpg;base64,二进制base64编码)
@property(nonatomic, copy)NSString *StartDateTime;
@property(nonatomic, copy)NSString *EndDateTime;
@property(nonatomic, copy)NSString *AttendanceCount;//请假总天数
@property(nonatomic, copy)NSArray  *Works;//工作安排

@end
