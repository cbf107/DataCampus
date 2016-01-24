//
//  NSString.h
//  MarketEleven
//
//  Created by Bergren Lam on 8/6/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GNUtil)

+ (NSString *) deviceADIdentifier;

- (NSString *)replaceAllWhiteSpace;

- (BOOL)isMobileNumber;
- (BOOL)isValidateEmail;
- (BOOL)isValidatePlateNumber;
- (BOOL)isPureInt;
- (BOOL)isPureFloat;

- (NSMutableAttributedString *)attributedStringSeparatedBy:(NSString *)sStr
                                                    color1:(UIColor *)c1
                                                    color2:(UIColor *)c2
                                                      font:(UIFont *)f;
- (NSMutableAttributedString *)attributedStringSeparatedBy:(NSString *)sStr
                                                    color1:(UIColor *)c1
                                                    color2:(UIColor *)c2
                                                     font1:(UIFont *)f1
                                                     font2:(UIFont *)f2;

- (NSMutableAttributedString *)attributedStringSeparatedBy:(NSString *)sStr
                                                    color1:(UIColor *)c1
                                                    color2:(UIColor *)c2
                                                      font:(UIFont *)f
                                                 lineSpace:(float)space;

- (NSString *)md5;

+ (NSString *)payPasswordWithPassword:(NSString *)password;

- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;

- (CGFloat) calculateHeightwithfont:(UIFont*)font andWidth:(CGFloat)width;
@end
