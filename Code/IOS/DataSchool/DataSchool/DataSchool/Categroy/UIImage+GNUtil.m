//
//  UIImage+GNUtil.m
//  MarketEleven
//
//  Created by coreyfu on 14-9-9.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//

#import "UIImage+GNUtil.h"

@implementation UIImage (GNUtil)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    @autoreleasepool {
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context,color.CGColor);
        
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return img;
        
    }
}

- (UIImage *)scaleImageToSize:(CGSize)size
{
    
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

+(UIImage *)imageNamed:(NSString *)name capInsets:(UIEdgeInsets)capInsets {
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:capInsets];
    return image;
    
}

@end
