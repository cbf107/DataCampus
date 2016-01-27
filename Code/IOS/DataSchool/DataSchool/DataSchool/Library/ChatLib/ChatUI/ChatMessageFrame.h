//
//  ChatMessageFrame.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//
#import "ChatMessage.h"

#define ChatTimeFont [UIFont systemFontOfSize:11]   //时间字体
#define ChatNameFont [UIFont systemFontOfSize:11]   //时间字体
#define ChatContentFont [UIFont systemFontOfSize:14]//内容字体
#define ChatVoiceTimeFont [UIFont systemFontOfSize:11]   //录音时间字体
#define ChatVoiceMarginLeft 8   //录音时间与内容间距

#define ChatContentMarginLeft 20  //文本内容与按钮左边缘间隔
#define ChatContentMarginV 8 //文本内容与按钮上下缘间隔
#define ChatContentMarginRight 15 //文本内容与按钮右边缘间隔

@interface ChatMessageFrame : NSObject

@property (nonatomic, readonly) CGRect nameF;
@property (nonatomic, readonly) CGRect iconF;
@property (nonatomic, readonly) CGRect timeF;
@property (nonatomic, readonly) CGRect voiceDurationF;
@property (nonatomic, readonly) CGRect contentF;

@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, strong) ChatMessage *message;
@property (nonatomic) BOOL showTime;//是否显示时间
@property (nonatomic) BOOL showName;//是否显示姓名
@property (nonatomic) BOOL firstMessage;//用于控制messagecell的高度,使其能显示正常的间距
@property (nonatomic) CGSize iconSize;//头像尺寸

@end
