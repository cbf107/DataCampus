//
//  ChineseString.h
//  YUChineseSorting
//
//  Created by yuzhx on 15/4/19.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pinyin.h"
#import "CommPropData.h"

@interface CityString : NSObject
@property(retain,nonatomic)CommPropData *mCommData;
@property(retain,nonatomic)NSString *pinYin;

//-----  返回tableview右方indexArray
+(NSMutableArray*)IndexArray:(NSArray*)commDataArr;

//-----  返回联系人
+(NSMutableArray*)LetterSortArray:(NSArray*)commDataArr;

///----------------------
//返回一组字母排序数组(中英混排)
+(NSMutableArray*)SortArray:(NSArray*)commDataArr;

@end