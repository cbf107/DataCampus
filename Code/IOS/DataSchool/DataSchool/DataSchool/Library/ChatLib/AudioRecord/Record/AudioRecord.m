//
//  GNAudioRecorder.m
//  MarketEleven
//
//  Created by Bergren Lam on 7/23/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import "AudioRecord.h"
#import "AmrWavConvert.h"
#import "AudioFileUtils.h"

@interface AudioRecord()<AVAudioRecorderDelegate>
@property (nonatomic, weak) id<AudioRecordDelegate> delegate;
@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@end

@implementation AudioRecord

#pragma mark - Init Methods

- (id)initWithDelegate:(id<AudioRecordDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

- (void)setRecorder
{
    _recorder = nil;
    NSError *recorderSetupError = nil;
    NSURL *url = [NSURL fileURLWithPath:[AudioFileUtils wavPath]];
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [settings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [settings setValue :[NSNumber numberWithFloat:8000] forKey: AVSampleRateKey];//44100.0
    //通道数
    [settings setValue :[NSNumber numberWithInt:1] forKey: AVNumberOfChannelsKey];
    //音频质量,采样质量
    [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    _recorder = [[AVAudioRecorder alloc] initWithURL:url
                                            settings:settings
                                               error:&recorderSetupError];
    if (recorderSetupError) {
        NSLog(@"%@",recorderSetupError);
    }
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;
    [_recorder prepareToRecord];
}

- (void)setSesstion
{
    _session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(_session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [_session setActive:YES error:nil];
}

#pragma mark - Public Methods

- (void)startRecord
{
    [self setSesstion];
    [self setRecorder];
    [_recorder record];
}


- (void)stopRecord
{
    double cTime = _recorder.currentTime;
    [_recorder stop];
    
    if (cTime > 2) {
        [self audio_WavToAmr];
    }else {
        
        [_recorder deleteRecording];
        
        if ([_delegate respondsToSelector:@selector(audioRecordFailRecord)]) {
            [_delegate audioRecordFailRecord];
        }
    }
}

- (void)cancelRecord
{
    [_recorder stop];
    [_recorder deleteRecording];
}



#pragma mark - Convert Utils
- (void)audio_WavToAmr
{
    NSString *wavFilePath = [AudioFileUtils wavPath];
    NSString *amrFilePath = [AudioFileUtils amrPath];
    
    // remove the old amr file
    [AudioFileUtils deleteAmrCache];
    
    NSLog(@"转换开始");
    if (_delegate && [_delegate respondsToSelector:@selector(audioRecordBeginConvert)]) {
        [_delegate audioRecordBeginConvert];
    }
    @try {
        [AmrWavConvert convertWAVFile:wavFilePath toAmrFile:amrFilePath];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    }
    
    NSData *data = [NSData dataWithContentsOfFile:wavFilePath];
    [AudioFileUtils deleteWavCache];
    
    NSLog(@"转换结束");
    if (_delegate && [_delegate respondsToSelector:@selector(audioRecordEndConvertWavData:toAmrData:)]) {
        NSData *voiceData = [NSData dataWithContentsOfFile:amrFilePath];
        [_delegate audioRecordEndConvertWavData:data toAmrData:voiceData];
    }
}





@end
