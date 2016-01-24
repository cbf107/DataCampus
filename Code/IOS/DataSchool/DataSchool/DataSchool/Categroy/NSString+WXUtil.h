//
//  NSString+WXUtil.h
//  EasyParking
//
//  Created by coreyfu on 15/4/13.
//  Copyright (c) 2015年 meineke. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    
    ContrastTypeAlphaNum = 1, //字母与数字
    ContrastTypeAlpha,        //纯字母
    ContrastTypeNumbers,      //纯数字
    ContrastTypeNumbersPeriod //数字.
    
};

typedef NSUInteger ContrastType;

@interface NSString (WXUtil)

//判断否输入的是否有字母或数字
- (BOOL)isEqualToAlphaAndNumType:(ContrastType)type;

//判断手机号码是否合法
- (BOOL)isMobileNumber;

//判断是否有中文
- (BOOL)isChinese;

//判断是否是邮箱
- (BOOL)isEmail;;

//判断是否有符号
- (BOOL)isSymbol;

//判断是否有数字
- (BOOL)isNumber;

//判断是否为空
- (BOOL)isNULL;

+ (NSString *)telNumberString:(NSString *)string;


// 字符串转换 NSDictionary --> NSString
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

// 字符串转换 NSArry --> NSString
+(NSString *) jsonStringWithArray:(NSArray *)array;

// 字符串转换 NSString --> NSString
+(NSString *) jsonStringWithString:(NSString *) string;

// 字符串转换 Object --> NSString
+(NSString *) jsonStringWithObject:(id) object;

@end
