//
//  GNUtil.h
//  MarketEleven
//
//  Created by Bergren Lam on 8/6/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GNDefine.h"
#import "NSString+GNUtil.h"
#import "UIColor+GNUtil.h"
#import "UIView+GNUtil.h"
#import "UILabel+GNUtil.h"
#import "UIAlertView+GNUtil.h"
#import "UIImage+GNUtil.h"
#import "NSArray+GNUtil.h"
#import "NSDate+GNUtil.h"
#import "NSTimer+GNUtil.h"
#import "UITextField+ShakeUITextField.h"
#import "NSObject+GNUtil.h"
#import "UIScreen+GNUtil.h"

@interface GNUtil : NSObject

+ (BOOL)needUpdateOfCurrentVersion:(NSString *)current serverVersion:(NSString *)server;
+ (BOOL)canConnectedToNetwork;

@end
