//
//  TabHomeCollCell.m
//  WanDaCloud
//
//  Created by mac on 15/8/28.
//  Copyright (c) 2015年 mac. All rights reserved.
//
#include "MMCell2.h"

@interface MMCell2()

@end


@implementation MMCell2
- (void)layoutSubviews
{
    UIImage *img = self.imageView.image;
    self.imageView.image = [UIImage imageNamed:@"schoolIcon"];
    [super layoutSubviews];
    self.imageView.image = img;

    self.imageView.layer.cornerRadius = 40;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    
}

@end