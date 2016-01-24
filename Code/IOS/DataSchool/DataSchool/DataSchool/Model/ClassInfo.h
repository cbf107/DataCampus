//
//  MessageInfo.h
//  ZhiKu
//
//  Created by mac on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "JSONModel.h"

@protocol ClassInfo
@end

@interface ClassInfo : JSONModel
@property (nonatomic, copy)NSString *sTitle;
@property (nonatomic, copy)NSString *sSubTitle;
@property (nonatomic, copy)NSString *sURL;
@property (nonatomic, assign)int iType;

@end

@protocol ClassInfos
@end

@interface ClassInfos : JSONModel
@property (nonatomic, copy)NSArray<ClassInfo> *ClassInfos;
@end
