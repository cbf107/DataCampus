//
//  UIScreen+GNUtil.m
//  MarketEleven
//
//  Created by bergren on 15/1/23.
//  Copyright (c) 2015年 Meinekechina. All rights reserved.
//

#import "UIScreen+GNUtil.h"

@implementation UIScreen (GNUtil)

+ (CGResolution)resolution {
    CGResolution r;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = [UIScreen mainScreen].bounds.size;
    r.width = size.width *scale;
    r.height = size.height *scale;
    return r;
}

@end
