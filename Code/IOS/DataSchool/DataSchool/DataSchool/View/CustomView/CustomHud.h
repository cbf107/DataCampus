//
//  CustomHud.h
//  WanDa
//
//  Created by coreyfu on 15/7/20.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomHud : UIView
+ (void)show;
+ (void)showInView:(UIView *)view;

+ (void)dismiss;

+ (void)setGifWithImages:(NSArray *)images;
+ (void)setGifWithImageName:(NSString *)imageName;
+ (void)setGifWithURL:(NSURL *)gifUrl;

@end
