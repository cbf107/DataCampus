//
//  UIImage+Extended.h
//  Categroy
//
//  Created by wuxin on 15/5/14.
//  Copyright (c) 2015年 wuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extended)

//颜色转图片
+ (UIImage*)createImageWithColor:(UIColor*)color;

//重置图片尺寸
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

//图片旋转
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

//缩放裁剪图片
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
