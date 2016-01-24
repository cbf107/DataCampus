//
//  UIColor+WXUtil.h
//  EasyParking
//
//  Created by wuxin on 15/4/27.
//  Copyright (c) 2015年 meineke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WXUtil)

+ (UIColor*)colorWithHexString:(NSString*)hex;

+ (UIColor*)colorWithHexString:(NSString*)hex withAlpha:(CGFloat)alpha;

+ (NSString *)hexFromUIColor: (UIColor*) color;

@end
