//
//  UITextField+WXUtil.m
//  EasyParking
//
//  Created by wuxin on 15/4/28.
//  Copyright (c) 2015年 meineke. All rights reserved.
//

#import "UITextField+WXUtil.h"

@implementation UITextField (WXUtil)

- (void)setPlaceholderColor:(UIColor *)color{
    [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}

@end
