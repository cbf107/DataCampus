//
//  CommonRequest.h
//  WanDa
//
//  Created by coreyfu on 15/7/21.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
//2.2.1获取系统编码表：p_api_sysCode
/*@interface SysCodeRequest : BaseRequest
@property(nonatomic, assign)int iType;    //分编码分类	Integer	null	为空时查出整个码表，传2表示维修类型
@property(nonatomic, assign)int iParentId; //父级主键	Integer	null	根据父级主键来获取
@property(nonatomic, assign)int iId; //父级主键	Integer	null	根据父级主键来获取
@end*/

//2.2.3用户登录：p_api_userLogin
@interface UserLoginRequest : BaseRequest
@property(nonatomic, copy)NSString *UserId; //	用户ID
@property(nonatomic, copy)NSString *Password; //用户密码
@property(nonatomic, copy)NSString *MemberRefId; //学校ID
@end

//获取用户信息
@interface GetUserProfileRequest : BaseRequest
@end

//获取首页侧滑栏菜单
@interface GetUserMenuRequest : BaseRequest
@end

//获取通知类型
@interface GetUserNotifyTypeRequest : BaseRequest
@end

//修改密码
@interface GetChangePWDRequest : BaseRequest
@property(nonatomic, copy)NSString *OldPassword; //老密码
@property(nonatomic, copy)NSString *NewPassword; //新密码
@end


//用户登录：p_api_userLogout
@interface UserLogoutRequest : BaseRequest
@end

//更新头像
@interface UpdateUserHeadRequest : BaseRequest
@property(nonatomic, copy)NSString *HeadImg; //头像图片
@end

//判断首页是否有未读消息
@interface GetReadLogRequest : BaseRequest
@property(nonatomic, copy)NSString *ClassName; //当前用户所在班级
@end

