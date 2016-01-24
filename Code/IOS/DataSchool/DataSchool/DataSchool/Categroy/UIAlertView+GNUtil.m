//
//  UIAlertView+GNHelper.m
//  citytime
//
//  Created by mac on 14-3-8.
//  Copyright (c) 2014年 wonler. All rights reserved.
//

#import "UIAlertView+GNUtil.h"

@implementation UIAlertView (GNUtil)


+(UIAlertView *)showWithTitle:(NSString *)title message:(NSString *)message {
    return [self showWithTitle:title message:message delegate:nil];
}

+(UIAlertView *)showWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate {
    if (!title) {
        title = @"温馨提示";
    }
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [a show];
    return a;
}


+(void)debugShowWithTitle:(NSString *)title message:(NSString *)message {
    
#ifdef DEBUG
    if (!title) {
        title = @"温馨提示";
    }
    NSString *tips = [NSString stringWithFormat:@"%@(DEBUG)",title];
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:tips message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [a show];
#else
#endif
}

@end
