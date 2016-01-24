//
//  ResponseHead.h
//  WanDa
//
//  Created by coreyfu on 15/7/21.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseHead : JSONModel
@property (nonatomic, assign) int errorCode; //错误代码	int
@property (retain, nonatomic) NSString *msg; //	简单消息	String	通常成功后都是“true”，错误时为简单说明
@property (nonatomic, assign) int use_time; //	数据逻辑层所花时间	int	用于调试使用
@property (nonatomic, assign) int update_count; //	更新的次数	int	执行数据逻辑时，（数据库中）进行更新操作的次数。
@property (retain, nonatomic) NSString *update_effects; //	更新的影响行数情况	String	每次执行更新时，所影响的行数（多个之间用逗号隔开）。
@property (nonatomic, assign) int result_count; //	返回的结果集数量	int	该结果中，结果body中列表集（List）的数量
@end
