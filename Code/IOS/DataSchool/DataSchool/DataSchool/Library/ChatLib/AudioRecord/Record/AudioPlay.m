//
//  GNAudioPlayer.m
//  MarketEleven
//
//  Created by Bergren Lam on 7/23/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import "AudioPlay.h"
#import "AmrWavConvert.h"
#import "AudioFileUtils.h"

@interface AudioPlay () <AVAudioPlayerDelegate>
{
    AVAudioPlayer *player;
}
@end

@implementation AudioPlay


+ (AudioPlay *)sharedInstance
{
    static AudioPlay *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)playSongWithUrl:(NSString *)songUrl
{
    
    [self.delegate audioPlayerBeiginLoadVoice];

    dispatch_async(dispatch_queue_create("dfsfe", NULL), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:MAKE_IMG_URL(songUrl)];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate audioPlayerFinishLoadVoice];
            
            if (data) {

                if (player) {
                    if (self.delegate) [self.delegate audioPlayerDidFinishPlay];
                    
                    [player stop];
                    player.delegate = nil;
                    player = nil;
                }
                    
                if([data writeToFile:[AudioFileUtils amrPath] atomically:YES]){
                    if([AmrWavConvert convertAmrFile:[AudioFileUtils amrPath] toWAVFile:[AudioFileUtils wavPath]]){
                        NSData *wavData = [NSData dataWithContentsOfFile:[AudioFileUtils wavPath]];
                        
                        NSError *playerError;
                        player = [[AVAudioPlayer alloc] initWithData:wavData error:&playerError];
                        player.volume = 1.0f;

                        if (player == nil){
                            NSLog(@"ERror creating player: %@", [playerError description]);
                        }
                        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
                        player.delegate = self;
                        [self addProximityObserver];
                        [player play];
                        [self.delegate audioPlayerBeiginPlay];
                    }
                }
            }else{
                if (self.delegate) [self.delegate audioPlayerDidFinishPlay];
            }
        });
    });
}

-(void)playSongWithData:(NSData *)songData
{
    if (self.delegate) [self.delegate audioPlayerDidFinishPlay];
    
    if (player) {
        [player stop];
        player.delegate = nil;
        player = nil;
    }
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"VoicePlayHasInterrupt" object:nil];
    NSError *playerError;
    player = [[AVAudioPlayer alloc]initWithData:songData error:&playerError];
    player.volume = 1.0f;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    player.delegate = self;
    [self addProximityObserver];
    [player play];
    [self.delegate audioPlayerBeiginPlay];
    
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    }else{
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

-(void)addProximityObserver {
    
    //return;
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
    
}

-(void)removeProximityObserver {
    //return;
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self removeProximityObserver];
    if (self.delegate) [self.delegate audioPlayerDidFinishPlay];
}

- (void)stopSound
{
    [self removeProximityObserver];
    if (player && player.isPlaying) {
        [player stop];
    }
}

- (BOOL)playing{
    return player.playing;
}

@end
