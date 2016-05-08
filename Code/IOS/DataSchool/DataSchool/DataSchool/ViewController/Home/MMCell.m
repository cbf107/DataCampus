//
//  TabHomeCollCell.m
//  WanDaCloud
//
//  Created by mac on 15/8/28.
//  Copyright (c) 2015年 mac. All rights reserved.
//
#include "MMCell.h"

@interface MMCell()

@end


@implementation MMCell
- (void)layoutSubviews
{
    UIImage *img = self.imageView.image;
    self.imageView.image = [UIImage imageNamed:@"menu_icon_default"];
    [super layoutSubviews];
    self.imageView.image = img;
}
@end