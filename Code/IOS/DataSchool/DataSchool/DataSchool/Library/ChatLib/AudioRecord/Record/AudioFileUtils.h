//
//  AudioFileUtils.h
//  MarketEleven
//
//  Created by coreyfu on 15/4/20.
//  Copyright (c) 2015年 Meinekechina. All rights reserved.
//


@interface AudioFileUtils : NSObject
+ (NSString *)wavPath;

+ (NSString *)amrPath;

+ (void)deleteAmrCache;

+ (void)deleteWavCache;

@end
