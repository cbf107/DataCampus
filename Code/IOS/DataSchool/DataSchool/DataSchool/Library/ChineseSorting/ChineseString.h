//
//  ChineseString.h
//  YUChineseSorting
//
//  Created by yuzhx on 15/4/19.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pinyin.h"
#import "LeaveInfo.h"

@interface ChineseString : NSObject
@property(retain,nonatomic)LeaveTeacher *leaveTeacher;
@property(retain,nonatomic)NSString *pinYin;

//-----  返回tableview右方indexArray
+(NSMutableArray*)IndexArray:(NSArray*)contactArr;

//-----  返回联系人
+(NSMutableArray*)LetterSortArray:(NSArray*)contactArr;

///----------------------
//返回一组字母排序数组(中英混排)
+(NSMutableArray*)SortArray:(NSArray*)contactArr;

@end