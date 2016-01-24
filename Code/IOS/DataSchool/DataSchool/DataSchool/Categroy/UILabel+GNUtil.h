//
//  UILabel+MEExtention.h
//  MarketEleven
//
//  Created by coreyfu on 14-8-4.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MEExtention)
- (CGSize)contentSizeFixWithSize:(CGSize)size;
- (CGSize)contentSizeFixWithWidth:(CGFloat)width;
- (CGSize)contentSizeFixWithHeight:(CGFloat)height;

- (void)setAttributedText:(NSString *)text lineSapcing:(CGFloat)lineSapcing;
- (void)markText:(NSString *)text withColor:(UIColor *)c;
- (void)markText:(NSString *)text withFont:(UIFont *)f color:(UIColor *)c;

@end
