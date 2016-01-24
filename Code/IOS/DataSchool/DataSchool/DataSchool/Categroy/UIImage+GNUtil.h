//
//  UIImage+GNUtil.h
//  MarketEleven
//
//  Created by coreyfu on 14-9-9.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//

@interface UIImage (GNUtil)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)scaleImageToSize:(CGSize)size;

+(UIImage *)imageNamed:(NSString *)name capInsets:(UIEdgeInsets)capInsets;

@end
