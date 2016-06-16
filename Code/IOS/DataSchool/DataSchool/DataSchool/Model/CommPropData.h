//
//  CommPropData.h
//  ZhiKu
//
//  Created by mac on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "JSONModel.h"

// 数据字典
@protocol CommPropData
@end

@interface CommPropData : JSONModel
//@property (nonatomic, copy) NSString *iCode;
@property (nonatomic, copy) NSString *sName;
@property (nonatomic, copy) NSString *sPinYin;
@end

@protocol CommPropDatas
@end
@interface CommPropDatas : JSONModel
@property (nonatomic, copy) NSArray<CommPropData> *Codes;
@end