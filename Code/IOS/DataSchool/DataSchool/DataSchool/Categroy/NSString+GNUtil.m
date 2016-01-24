//
//  NSString.m
//  MarketEleven
//
//  Created by Bergren Lam on 8/6/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import "NSString+GNUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>


@implementation NSString (GNUtil)


+ (NSString *)deviceADIdentifier
{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

- (NSString *)replaceAllWhiteSpace
{
    NSArray *filteredArray2;
    @autoreleasepool {
        
        NSCharacterSet *whitespaces = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
        
        
        
        NSArray *parts = [self componentsSeparatedByCharactersInSet:whitespaces];
        
        NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
        
        NSString *theString = [filteredArray componentsJoinedByString:@""];
        
        NSArray *parts2 = [theString componentsSeparatedByCharactersInSet:[NSCharacterSet controlCharacterSet]];
        
        filteredArray2 = [[NSArray alloc] initWithArray:[parts2 filteredArrayUsingPredicate:noEmptyStrings]];
    }
    
    return [filteredArray2 componentsJoinedByString:@""];
}

//检测是否是手机号码
- (BOOL)isMobileNumber
{
    
    if ([self hasPrefix:@"1"]) {
        
        if (self.length == 11 && [self isPureInt]) {
            return YES;
        }
    }
    
    return NO;
    
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[01235-9])\\d{8}$";
//    
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    //NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    //NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    //NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    //NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    //NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    //NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    
//    if (([regextestmobile evaluateWithObject:self] == YES)
//        /*&& ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextestct evaluateWithObject:mobileNum] == YES)
//         || ([regextestcu evaluateWithObject:mobileNum] == YES)*/)
//    {
//        return YES;
//    }else{
//        return NO;
//    }
}

-(BOOL)isValidateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}


- (BOOL)isValidatePlateNumber
{
    NSString *carRegex = @"^[/京|津|沪|川|鄂|赣|贵|黑|吉|冀|晋|辽|鲁|云|蒙|苏|浙|皖|闽|豫|湘|粤|桂|琼|渝|陕|甘|青|宁|新|贵|藏/]{1}[A-Za-z0-9]{6}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    

    return [carTest evaluateWithObject:self];
}

- (BOOL)isPureFloat
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (NSMutableAttributedString *)attributedStringSeparatedBy:(NSString *)sStr
                                                    color1:(UIColor *)c1
                                                    color2:(UIColor *)c2
                                                      font:(UIFont *)f
{
    if (self.length == 0) return nil;
    
    NSArray *arr = [self componentsSeparatedByString:sStr];
    if (arr.count < 2) return nil;
    
    NSRange rangeLeft = NSMakeRange(0, [arr[0] length]);
    NSRange rangeMiddle = NSMakeRange(rangeLeft.length, sStr.length);
    NSRange rangeRight = NSMakeRange(rangeLeft.length + rangeMiddle.length, [arr[1] length]);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    
    [str addAttribute:NSForegroundColorAttributeName value:c1 range:rangeLeft];
    [str addAttribute:NSForegroundColorAttributeName value:c1 range:rangeMiddle];
    [str addAttribute:NSForegroundColorAttributeName value:c2 range:rangeRight];
    
    [str addAttribute:NSFontAttributeName value:f range:rangeLeft];
    [str addAttribute:NSFontAttributeName value:f range:rangeMiddle];
    [str addAttribute:NSFontAttributeName value:f range:rangeRight];
    
    return str;
}

- (NSMutableAttributedString *)attributedStringSeparatedBy:(NSString *)sStr
                                                    color1:(UIColor *)c1
                                                    color2:(UIColor *)c2
                                                     font1:(UIFont *)f1
                                                     font2:(UIFont *)f2
{
    if (self.length == 0) return nil;
    
    NSArray *arr = [self componentsSeparatedByString:sStr];
    if (arr.count < 2) return nil;
    
    NSRange rangeLeft = NSMakeRange(0, [arr[0] length]);
    NSRange rangeMiddle = NSMakeRange(rangeLeft.length, sStr.length);
    NSRange rangeRight = NSMakeRange(rangeLeft.length + rangeMiddle.length, [arr[1] length]);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    
    [str addAttribute:NSForegroundColorAttributeName value:c1 range:rangeLeft];
    [str addAttribute:NSForegroundColorAttributeName value:c1 range:rangeMiddle];
    [str addAttribute:NSForegroundColorAttributeName value:c2 range:rangeRight];
    
    [str addAttribute:NSFontAttributeName value:f1 range:rangeLeft];
    [str addAttribute:NSFontAttributeName value:f1 range:rangeMiddle];
    [str addAttribute:NSFontAttributeName value:f2 range:rangeRight];
    
    return str;
}

- (NSMutableAttributedString *)attributedStringSeparatedBy:(NSString *)sStr
                                                    color1:(UIColor *)c1
                                                    color2:(UIColor *)c2
                                                      font:(UIFont *)f
                                                 lineSpace:(float)space
{
    if (self.length == 0) return nil;
    
    NSArray *arr = [self componentsSeparatedByString:sStr];
    if (arr.count < 2) return nil;
    
    NSRange rangeLeft = NSMakeRange(0, [arr[0] length]);
    NSRange rangeMiddle = NSMakeRange(rangeLeft.length, sStr.length);
    NSRange rangeRight = NSMakeRange(rangeLeft.length + rangeMiddle.length, [arr[1] length]);
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = space;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    
    [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [self length])];

    [str addAttribute:NSForegroundColorAttributeName value:c1 range:rangeLeft];
    [str addAttribute:NSForegroundColorAttributeName value:c1 range:rangeMiddle];
    [str addAttribute:NSForegroundColorAttributeName value:c2 range:rangeRight];
    
    [str addAttribute:NSFontAttributeName value:f range:rangeLeft];
    [str addAttribute:NSFontAttributeName value:f range:rangeMiddle];
    [str addAttribute:NSFontAttributeName value:f range:rangeRight];
    
    return str;
}

- (NSString *)md5{
    const char *cStr = [self?self:@"" UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result);
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]] lowercaseString];
}

+ (NSString *)payPasswordWithPassword:(NSString *)password {
    NSString *payPassword = password;
    
    payPassword = [payPassword md5];
    payPassword = [NSString stringWithFormat:@"www.auto11.com%@www.auto11.com", payPassword];
    payPassword = [payPassword md5];
    payPassword = [NSString stringWithFormat:@"www.auto11.com%@www.auto11.com", payPassword];
    return [payPassword md5];
    
}

- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else {
        expectedLabelSize = [self sizeWithFont:font
                             constrainedToSize:size
                                 lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}



- (CGFloat) calculateHeightwithfont:(UIFont*)font andWidth:(CGFloat)width
{
//    //[self boundingRectWithSize:CGSizeMake(self.frame.size.width - 72, MAXFLOAT)
//                                                          options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}
//                                                          context:nil].size;
    
    CGSize expectedLabelSize = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                               options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes:attributes context:nil].size;
    }
    else {
        expectedLabelSize = [self sizeWithFont:font
                             constrainedToSize:CGSizeMake(width, MAXFLOAT)
                                 lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return expectedLabelSize.height;
}

@end
