//
//  MessageInfo.h
//  ZhiKu
//
//  Created by mac on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "JSONModel.h"

/*@protocol UserClass
@end

@interface UserClass : JSONModel
@property (nonatomic, copy)NSString *ClassName;
@end*/




@protocol UserProfile
@end

@interface UserProfile : JSONModel
@property (nonatomic, copy)NSString *UserID;
@property (nonatomic, copy)NSString *UserType;
@property (nonatomic, copy)NSString *UserImage;
@property (nonatomic, copy)NSArray<UserClass> *UserClasses;
@property (nonatomic, copy)NSString *UserGrade;
@property (nonatomic, copy)NSString *UserName;
@property (nonatomic, copy)NSString *UserNum;
@property (nonatomic, copy)NSString *UserQRCode;

@end
