//
//  AmrWavConvert.h
//  MarketEleven
//
//  Created by bergren on 15/3/23.
//  Copyright (c) 2015年 Meinekechina. All rights reserved.
//

@interface AmrWavConvert : NSObject
+ (BOOL)convertAmrFile:(NSString *)amrFilePath toWAVFile:(NSString *)wavFilePath;
+ (BOOL)convertWAVFile:(NSString *)wavFilePath toAmrFile:(NSString *)amrFilePath;
@end
