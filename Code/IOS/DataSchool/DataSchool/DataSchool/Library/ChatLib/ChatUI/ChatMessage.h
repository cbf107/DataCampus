//
//  ChatMessage.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EChatMessageType) {
    EChatMessageTypeText     = 0 , // 文字
    EChatMessageTypePicture  = 1 , // 图片
    EChatMessageTypeVoice    = 2   // 语音
};

typedef NS_ENUM(NSInteger, EChatMessageFrom) {
    EChatMessageFromMe       = 0,   // 自己发的
    EChatMessageFromOther    = 1    // 别人发得
};

typedef NS_ENUM(NSInteger, EChatVoiceDataType) {
    EChatVoiceDataTypeOriginal   = 0,   // /录音的原始文件  wav
    EChatVoiceDataTypeAMR        = 1 ,   // 录音之后转换为amr
    EChatVoiceDataTypeWAV        = 2,    //网上下载的amr转换为wav
};

@interface ChatMessage : NSObject

@property (nonatomic, copy) NSString *strIcon; //头像地址
@property (nonatomic, copy) NSString *strId;   //用户id
@property (nonatomic, copy) NSString *strTime; //消息创建时间
@property (nonatomic, copy) NSString *strName; //用户名字

@property (nonatomic, copy) NSString *strContent;//文字内容
@property (nonatomic, copy) NSString *voiceAmrUrl;//文字内容

@property (nonatomic, copy) UIImage  *picture;  //图片
@property (nonatomic, copy) NSString  *pictureUrl;  //图片
@property (nonatomic, copy) NSData   *voiceWav;    //语音数据
@property (nonatomic, copy) NSData   *voiceAmr;    //语音数据
@property (nonatomic, copy) NSString *strVoiceTime;//语音时长
@property (nonatomic) NSTimeInterval duration;//语音时长

@property (nonatomic, assign) EChatMessageType messageType;//消息类型
@property (nonatomic, assign) EChatMessageFrom fromType;//消息来源
@property (nonatomic, assign) EChatVoiceDataType voiceDataType;//语音数据类型

@property (nonatomic, assign) BOOL showDate;//是否显示本消息时间

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end;
//- (MutilmediaMsgInfo *)makeMutilmediaMsgInfo;
@end
