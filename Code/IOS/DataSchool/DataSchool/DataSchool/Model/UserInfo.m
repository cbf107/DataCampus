//
//  UserInfo.m
//  WanDaCloud
//
//  Created by coreyfu on 14/11/16.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//

#import "UserInfo.h"
@implementation UserClass
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]) != nil)
    {
        self.ClassName = [aDecoder decodeObjectForKey:@"ClassName"];
        self.Principal = [aDecoder decodeObjectForKey:@"Principal"];
        self.PhoneNum = [aDecoder decodeObjectForKey:@"PhoneNum"];
        self.URL = [aDecoder decodeObjectForKey:@"URL"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ClassName forKey:@"ClassName"];
    [aCoder encodeObject:self.Principal forKey:@"Principal"];
    [aCoder encodeObject:self.PhoneNum forKey:@"PhoneNum"];
    [aCoder encodeObject:self.URL forKey:@"URL"];
}
@end



@implementation UserInfo
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(UserInfo *)clone{
    UserInfo *userInfo = [[UserInfo alloc] init];
    userInfo.UserRefId = [NSString stringWithString:self.UserRefId];
    userInfo.UserId = [NSString stringWithString:self.UserId];
    userInfo.MemberRefId = [NSString stringWithString:self.MemberRefId];

    userInfo.Icon = [NSString stringWithString:self.Icon];
    userInfo.UserClasses = self.UserClasses;
    userInfo.CurrentUserClass = [NSString stringWithString:self.CurrentUserClass];

    userInfo.UserType = [NSString stringWithString:self.UserType];
    userInfo.UserGrade = [NSString stringWithString:self.UserGrade];
    userInfo.UserName = [NSString stringWithString:self.UserName];
    userInfo.UserNum = [NSString stringWithString:self.UserNum];
    userInfo.UserQRURL = [NSString stringWithString:self.UserQRURL];
    return userInfo;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]) != nil)
    {
        self.UserId = [aDecoder decodeObjectForKey:@"UserId"];
        self.MemberRefId = [aDecoder decodeObjectForKey:@"MemberRefId"];

        self.UserRefId = [aDecoder decodeObjectForKey:@"UserRefId"];
        self.Icon = [aDecoder decodeObjectForKey:@"Icon"];
        self.UserClasses = [aDecoder decodeObjectForKey:@"UserClasses"];
        self.CurrentUserClass = [aDecoder decodeObjectForKey:@"CurrentUserClass"];

        self.UserType = [aDecoder decodeObjectForKey:@"UserType"];
        self.UserGrade = [aDecoder decodeObjectForKey:@"UserGrade"];
        self.UserName = [aDecoder decodeObjectForKey:@"UserName"];
        self.UserNum = [aDecoder decodeObjectForKey:@"UserNum"];
        self.UserQRURL = [aDecoder decodeObjectForKey:@"UserQRURL"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.UserId forKey:@"UserId"];
    [aCoder encodeObject:self.MemberRefId forKey:@"MemberRefId"];

    [aCoder encodeObject:self.UserRefId forKey:@"UserRefId"];
    [aCoder encodeObject:self.Icon forKey:@"Icon"];
    [aCoder encodeObject:self.UserClasses forKey:@"UserClasses"];
    [aCoder encodeObject:self.CurrentUserClass forKey:@"CurrentUserClass"];

    [aCoder encodeObject:self.UserType forKey:@"UserType"];
    [aCoder encodeObject:self.UserGrade forKey:@"UserGrade"];
    [aCoder encodeObject:self.UserName forKey:@"UserName"];
    [aCoder encodeObject:self.UserNum forKey:@"UserNum"];
    [aCoder encodeObject:self.UserQRURL forKey:@"UserQRURL"];
}
@end
