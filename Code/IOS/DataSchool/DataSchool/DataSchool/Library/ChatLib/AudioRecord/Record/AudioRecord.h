//
//  GNAudioRecorder.h
//  MarketEleven
//
//  Created by Bergren Lam on 7/23/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "AmrWavConvert.h"


@protocol AudioRecordDelegate;

@interface AudioRecord : NSObject

- (id)initWithDelegate:(id<AudioRecordDelegate>)delegate;
- (void)startRecord;
- (void)stopRecord;
- (void)cancelRecord;

@end


@protocol AudioRecordDelegate <NSObject>

@optional

- (void)audioRecordFailRecord;
- (void)audioRecordBeginConvert;
- (void)audioRecordEndConvertWavData:(NSData *)data toAmrData:(NSData *)voiceData;

@end