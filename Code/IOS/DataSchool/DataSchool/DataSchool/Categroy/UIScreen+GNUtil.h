//
//  UIScreen+GNUtil.h
//  MarketEleven
//
//  Created by bergren on 15/1/23.
//  Copyright (c) 2015年 Meinekechina. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    CGFloat width;
    CGFloat height;
}CGResolution;

@interface UIScreen (GNUtil)

+ (CGResolution)resolution;

@end
