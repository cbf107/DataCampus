//
//  UIAlertView+GNHelper.h
//  citytime
//
//  Created by mac on 14-3-8.
//  Copyright (c) 2014年 wonler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (GNUtil)


+(UIAlertView *)showWithTitle:(NSString *)title message:(NSString *)message;
+(UIAlertView *)showWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;



+(void)debugShowWithTitle:(NSString *)title message:(NSString *)message;
@end
