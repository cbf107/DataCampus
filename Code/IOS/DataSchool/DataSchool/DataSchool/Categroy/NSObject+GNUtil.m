//
//  NSObject+GNUtil.m
//  MarketEleven
//
//  Created by Bergren Lam on 12/2/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import "NSObject+GNUtil.h"

@implementation NSObject (GNUtil)

- (BOOL)isNull {
    if (!self || [self isKindOfClass:[NSNull class]]) {
        return YES;
    }else {
        return NO;
    }
}

@end
