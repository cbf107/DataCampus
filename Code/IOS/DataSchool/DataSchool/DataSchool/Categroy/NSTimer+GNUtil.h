//
//  NSTimer+GNUtil.h
//  MarketEleven
//
//  Created by Bergren Lam on 10/23/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (GNUtil)

+ (NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats mode:(NSString *)mode;

@end
