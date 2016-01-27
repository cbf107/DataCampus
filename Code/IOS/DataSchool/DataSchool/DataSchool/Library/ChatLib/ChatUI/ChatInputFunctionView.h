//
//  UUInputFunctionView.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatInputFunctionView;

@protocol ChatInputFunctionViewDelegate <NSObject>

// text
- (void)chatInputFunctionView:(ChatInputFunctionView *)funcView sendMessage:(NSString *)message;

// image
- (void)chatInputFunctionView:(ChatInputFunctionView *)funcView sendPicture:(UIImage *)image;

// audio
- (void)chatInputFunctionView:(ChatInputFunctionView *)funcView sendVoiceWav:(NSData *)wav voiceAmr:(NSData *)amr time:(NSInteger)second;

@end

@interface ChatInputFunctionView : UIView <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *btnSendMessage;
@property (nonatomic, strong) UIButton *btnMore;
@property (nonatomic, strong) UIButton *btnChangeVoiceState;
@property (nonatomic, strong) UIButton *btnVoiceRecord;
@property (nonatomic, strong) UITextView *textViewInput;

@property (nonatomic) BOOL isAbleToSendTextMessage;

@property (nonatomic, strong) UIViewController *superVC;

@property (nonatomic, weak) id<ChatInputFunctionViewDelegate>delegate;


- (id)initWithSuperVC:(UIViewController *)superVC;

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto;

@end
