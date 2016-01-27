//
//  AudioFileUtils.m
//  MarketEleven
//
//  Created by coreyfu on 15/4/20.
//  Copyright (c) 2015年 Meinekechina. All rights reserved.
//

#import "AudioFileUtils.h"

@implementation AudioFileUtils

#pragma mark - Path Utils
+ (NSString *)wavPath
{
    NSString *wavPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"voice.wav"];
    return wavPath;
}

+ (NSString *)amrPath
{
    NSString *amrPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"voice.amr"];
    return amrPath;
}

+ (void)deleteAmrCache
{
    [self deleteFileWithPath:[self amrPath]];
}

+ (void)deleteWavCache
{
    [self deleteFileWithPath:[self wavPath]];
}

+ (void)deleteFileWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:path error:nil])
    {
        NSLog(@"删除以前的amr文件");
    }
}

@end
