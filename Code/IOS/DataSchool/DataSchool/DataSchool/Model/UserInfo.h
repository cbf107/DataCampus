//
//  UserInfo.h
//  WanDaCloud
//
//  Created by coreyfu on 14/11/16.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"


@protocol UserClass
@end

@interface UserClass : JSONModel<NSCoding>
@property (nonatomic, copy)NSString *ClassName;
@property (nonatomic, copy)NSString *Principal;
@property (nonatomic, copy)NSString *PhoneNum;
@property (nonatomic, copy)NSString *URL;
@end




@protocol UserInfo
@end

@interface UserInfo : JSONModel
@property (nonatomic, copy)NSString *UserId;
@property (nonatomic, copy)NSString *UserRefId;
@property (nonatomic, copy)NSString *Icon;
@property (retain, nonatomic) NSArray<UserClass> *UserClasses; //所属班级
@property (nonatomic, copy)NSString *CurrentUserClass;

@property (nonatomic, copy)NSString *MemberRefId;
@property (nonatomic, copy)NSString *UserType;
@property (nonatomic, copy)NSString *UserGrade;
@property (nonatomic, copy)NSString *UserName;
@property (nonatomic, copy)NSString *UserNum;
@property (nonatomic, copy)NSString *UserQRURL;
@property (nonatomic, copy)NSString *UserAboutURL;


+(BOOL)propertyIsOptional:(NSString*)propertyName;
-(UserInfo *)clone;
@end
