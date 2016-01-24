//
//  NSString+WXUtil.m
//  EasyParking
//
//  Created by coreyfu on 15/4/13.
//  Copyright (c) 2015年 meineke. All rights reserved.
//

#import "NSString+WXUtil.h"

#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define kNumbers     @"0123456789"
#define kNumbersPeriod @"0123456789."
#define Symbol @",<.>/?;:'[{]}`~""!\\@#$%^&*()_+·！￥%……&…*（）——【】、||：“”‘’；，。《》？—"

@implementation NSString (WXUtil)

- (BOOL)isEqualToAlphaAndNumType:(ContrastType)type{

    NSString *contrastType;
    NSString *string;
    BOOL basic = NO;
    switch (type) {
        case 1:contrastType = kAlphaNum;      break;
        case 2:contrastType = kAlpha;         break;
        case 3:contrastType = kNumbers;       break;
        case 4:contrastType = kNumbersPeriod; break;
        default: break;
    }
    
    for (int i=0; i<[self length]; i++) {
        string = [self substringWithRange:NSMakeRange(i, 1)];
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:contrastType] invertedSet];
        NSString *filtered =
        [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if ([string isEqualToString:filtered]) {
            basic = YES;
            break;
        }
   }
    
    return basic;
}

- (BOOL)isMobileNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString *_tel = @"^1[3-9]\\d{9}$";
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestct2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _tel];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        ||  ([regextestcm evaluateWithObject:self] == YES)
        ||  ([regextestct evaluateWithObject:self] == YES)
        ||  ([regextestcu evaluateWithObject:self] == YES)
        ||  ([regextestct2 evaluateWithObject:self] == YES)){
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)isChinese{
    
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isSymbol{
    NSString *string;
    BOOL basic = NO;
    for (int i=0; i<[self length]; i++) {
        string = [self substringWithRange:NSMakeRange(i, 1)];
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:Symbol] invertedSet];
        NSString *filtered =
        [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if ([string isEqualToString:filtered]) {
            basic = YES;
            break;
        }
    }
    return basic;
}

- (BOOL)isNumber{
    NSString *string;
    BOOL basic = NO;
    for (int i=0; i<[self length]; i++) {
        string = [self substringWithRange:NSMakeRange(i, 1)];
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbers] invertedSet];
        NSString *filtered =
        [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if ([string isEqualToString:filtered]) {
            basic = YES;
            break;
        }
    }
    return basic;
}

- (BOOL)isNULL{
    if ([self isEqualToString:@""] || self == nil) {
        return YES;
    }
    return NO;
}

- (BOOL)isEmail{
    NSArray *array = [self componentsSeparatedByString:@"."];
    if ([array count] >= 4) {
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

+ (NSString *)telNumberString:(NSString *)string{
    if (![string isNULL]&&string.length == 11) {
        NSString *str1 = [string substringWithRange:NSMakeRange(0, 3)];
        NSString *str2 = [string substringWithRange:NSMakeRange(7, 4)];
        return [NSString stringWithFormat:@"%@****%@",str1,str2];
    }else{
        return @"";
    }
}


// 字符串转换 NSDictionary --> NSString
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    
    [reString appendString:@"{"];
    
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    
    return reString;
}

// 字符串转换 NSArry --> NSString
+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    
    return reString;
}

// 字符串转换 NSString --> NSString
+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

// 字符串转换 Object --> NSString
+(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString jsonStringWithArray:object];
    }else if([object isKindOfClass:[NSNumber class]]){
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        value = [numberFormatter stringFromNumber:object];
    }
    
    return value;
}

@end
