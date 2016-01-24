//
//  NSTimer+GNUtil.m
//  MarketEleven
//
//  Created by Bergren Lam on 10/23/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import "NSTimer+GNUtil.h"

@implementation NSTimer (GNUtil)

+ (NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats mode:(NSString *)mode
{
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(eoc_blockInvoke:) userInfo:[block copy] repeats:repeats];
    
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:mode];
    
    return timer;
}

+ (void)eoc_blockInvoke:(NSTimer*)timer {
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
