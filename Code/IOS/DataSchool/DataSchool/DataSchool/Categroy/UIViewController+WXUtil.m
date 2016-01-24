//
//  UIViewController+WXUtil.m
//  CasuallyStop
//
//  Created by coreyfu on 15/4/7.
//  Copyright (c) 2015年 meineke. All rights reserved.
//

#import "UIViewController+WXUtil.h"

@implementation UIViewController (WXUtil)

+ (UIViewController *)viewControllerWithStoryboard:(NSString *)storyboard identifier:(NSString *)identify
{
    NSString *name = storyboard;
    if (!name) name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIMainStoryboardFile"];
    
    if (!name) name = @"MainStoryboard";
    
    UIStoryboard *stryBoard=[UIStoryboard storyboardWithName:name bundle:nil];
    return  [stryBoard instantiateViewControllerWithIdentifier:identify];
}


@end
