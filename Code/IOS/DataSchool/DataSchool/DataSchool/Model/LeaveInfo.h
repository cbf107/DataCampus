//
//  UserMenu.h
//  ZhiKu
//
//  Created by mac on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "JSONModel.h"

@protocol LeaveType
@end

@interface LeaveType : JSONModel
@property (nonatomic, copy)NSString *ItemName;
//@property (nonatomic, copy)NSString *ItemValue;
//@property (nonatomic, copy)NSString *ItemComment;
@end


@protocol LeaveWork
@end

@interface LeaveWork : JSONModel
@property (nonatomic, copy)NSString *ItemName;
//@property (nonatomic, copy)NSString *ItemValue;
//@property (nonatomic, copy)NSString *ItemComment;
@end

@protocol LeaveTeacher
@end

@interface LeaveTeacher : JSONModel
@property (nonatomic, copy)NSString *ItemName;
//@property (nonatomic, copy)NSString *ItemValue;
//@property (nonatomic, copy)NSString *ItemComment;
@end
