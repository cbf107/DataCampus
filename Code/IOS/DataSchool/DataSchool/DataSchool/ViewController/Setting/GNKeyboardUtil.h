//
//  GNKeyboardUtil.h
//  MarketEleven
//
//  Created by Bergren Lam on 8/26/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNKeyboardUtil : NSObject

+(void)addKeyboardObserverForAdjustView:(UIView *)adjustView;

+(void)removeKeyboradObserver;

@end
