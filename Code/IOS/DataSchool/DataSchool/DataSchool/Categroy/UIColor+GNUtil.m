//
//  UIColor+GNUtil.m
//  MarketEleven
//
//  Created by Bergren Lam on 8/6/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import "UIColor+GNUtil.h"

@implementation UIColor (GNUtil)

+(UIColor *)randomColor{
    static BOOL seed = NO;
    if (!seed) {
        seed = YES;
        srandom((unsigned)time(NULL));
    }
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return nil;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return nil;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//+ (UIColor *)appBackgroundColor
//{
//    return [UIColor colorWithHexString:kAppBackgroundColor];
//}
//
//+ (UIColor *)appBackgroundColorDark
//{
//    return [UIColor colorWithHexString:kAppBackgroundColorDark];
//
//}
//
//+ (UIColor *)appBackgroundColorLight
//{
//    return [UIColor colorWithHexString:kAppBackgroundColorLight];
//
//}
//
//+ (UIColor *)appBackgroundColorYellow
//{
//    return [UIColor colorWithHexString:kAppBackgroundColorYellow];
//    
//}
//
+ (UIColor *)appEdgeLineColor
{
    return [UIColor colorWithHexString:kAppColorGraybkg]; //kAppEdgeLineColor];
    
}

+ (UIColor *)appFontColorLight
{
    return [UIColor colorWithHexString:kAppFontColorLight];
    
}
+ (UIColor *)appFontColorDark
{
    return [UIColor colorWithHexString:kAppFontColorDark];
    
}
+ (UIColor *)appFontColor
{
    return [UIColor colorWithHexString:kAppFontColor];
    
}
//+ (UIColor *)appFontColorRed
//{
//    return [UIColor colorWithHexString:kAppFontColorRed];
//
//}
+ (UIColor *)appFontColorBlue
{
    return [UIColor colorWithHexString:kAppFontColorBlue];
    
}

+ (UIColor *)realBarTintColor:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a
{
    CGFloat red = r, green = g, blue = b, alpha = a;
    
    CGFloat defaultOpacity = 0.4;
    
    CGFloat minVal = MIN(MIN(red, green), blue);
    
    CGFloat (^convertValueFunc)(CGFloat,CGFloat) = ^(CGFloat value,CGFloat opacity){
        return (CGFloat)(0.4 * value / opacity + 0.6 * value - 0.4 / opacity + 0.4);
    };
    
    if (convertValueFunc(minVal,defaultOpacity) < 0) {
        defaultOpacity = (0.4 - 0.4 * minVal) / (0.6 * minVal + 0.4);
    }
    
    red = convertValueFunc(red,defaultOpacity);
    green = convertValueFunc(green,defaultOpacity);
    blue = convertValueFunc(blue,defaultOpacity);
    
    red = MAX(MIN(1.0, red), 0);
    green = MAX(MIN(1.0, green), 0);
    blue = MAX(MIN(1.0, blue), 0);
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
}

@end
