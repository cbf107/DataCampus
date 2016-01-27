//
//  GNAudioPlayer.h
//  MarketEleven
//
//  Created by Bergren Lam on 7/23/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>


@protocol AudioPlayDelegate <NSObject>
@optional
- (void)audioPlayerBeiginLoadVoice;
- (void)audioPlayerFinishLoadVoice;

- (void)audioPlayerBeiginPlay;
- (void)audioPlayerDidFinishPlay;

@end

@interface AudioPlay : NSObject

@property (nonatomic, weak)id <AudioPlayDelegate>delegate;
+ (AudioPlay *)sharedInstance;

-(void)playSongWithUrl:(NSString *)songUrl;
-(void)playSongWithData:(NSData *)songData;

- (void)stopSound;
- (BOOL)playing;
@end