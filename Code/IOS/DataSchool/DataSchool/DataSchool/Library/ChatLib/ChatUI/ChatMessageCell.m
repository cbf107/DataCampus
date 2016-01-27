//
//  UUMessageCell.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "ChatMessageCell.h"
#import "ChatMessage.h"
#import "ChatMessageFrame.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "UIButton+WebCache.h"

@interface ChatMessageCell ()<ChatMessageContentButtonDelegate>
@property (nonatomic, strong) ChatMessageContentButton *btnContent;
@property (nonatomic, strong) UIView *headImageBackView;

@end

@implementation ChatMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        // 1、创建时间
        self.labelTime = [[UILabel alloc] init];
        self.labelTime.textAlignment = NSTextAlignmentCenter;
        self.labelTime.textColor = [UIColor grayColor];
        self.labelTime.font = ChatTimeFont;
        [self.contentView addSubview:self.labelTime];
        
        // 2、创建头像
        _headImageBackView = [[UIView alloc] init];
        _headImageBackView.layer.masksToBounds = YES;
        //_headImageBackView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [self.contentView addSubview:_headImageBackView];
        self.btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHeadImage.layer.masksToBounds = YES;
        [self.btnHeadImage addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [_headImageBackView addSubview:self.btnHeadImage];
        
        // 3、创建头像下标
        /*
        self.labelNum = [[UILabel alloc] init];
        self.labelNum.textColor = [UIColor grayColor];
        self.labelNum.textAlignment = NSTextAlignmentCenter;
        self.labelNum.font = ChatTimeFont;
        [self.contentView addSubview:self.labelNum];
        */
        
        // 4、创建内容
        self.btnContent = [ChatMessageContentButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.btnContent];
        self.btnContent.delegate = self;
        
        // 5、创建语音时长
        self.labelVoiceTime = [[UILabel alloc] init];
        self.labelVoiceTime.textColor = [UIColor lightGrayColor];
        self.labelVoiceTime.font = ChatVoiceTimeFont;
        [self.contentView addSubview:self.labelVoiceTime];
        
    }
    return self;
}

- (void)setEnableLongPress:(BOOL)enable{
    _enableLongPress = enable;
    
    self.btnContent.enableLongPress = enable;
}

//头像点击
- (void)btnHeadImageClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(headImageDidClick:userId:)])  {
        [self.delegate headImageDidClick:self userId:self.messageFrame.message.strId];
    }
}

//内容及Frame设置
- (void)setMessageFrame:(ChatMessageFrame *)messageFrame{

    _messageFrame = messageFrame;
    ChatMessage *message = messageFrame.message;
    
    // 1、设置时间
    self.labelTime.text = message.strTime;
    self.labelTime.frame = messageFrame.timeF;
    
    // 2、设置头像
    self.headImageBackView.frame = messageFrame.iconF;
    self.headImageBackView.backgroundColor = [UIColor whiteColor];
    
    // 3、设置时间
    self.labelVoiceTime.frame = messageFrame.voiceDurationF;

    self.btnHeadImage.frame = CGRectMake(2, 2, messageFrame.iconSize.width - 4, messageFrame.iconSize.height - 4);
    self.btnHeadImage.layer.cornerRadius = self.btnHeadImage.frame.size.width * 0.5;
    //self.headImageBackView.layer.cornerRadius = messageFrame.iconSize.width * 0.5;

    if (message.fromType == EChatMessageFromMe) {
        [self.btnHeadImage sd_setBackgroundImageWithURL:MAKE_IMG_URL(message.strIcon) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"chatDefault"]];
    }else{
        [self.btnHeadImage sd_setBackgroundImageWithURL:MAKE_IMG_URL(message.strIcon) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"chatDefault"]];
    }
    
    // 3、设置下标
    /*
    self.labelNum.text = message.strName;
    if (messageFrame.nameF.origin.x > 160) {
        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x - 50, messageFrame.nameF.origin.y + 3, 100, messageFrame.nameF.size.height);
        self.labelNum.textAlignment = NSTextAlignmentRight;
    }else{
        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x, messageFrame.nameF.origin.y + 3, 80, messageFrame.nameF.size.height);
        self.labelNum.textAlignment = NSTextAlignmentLeft;
    }
     */
    // 4、设置内容
    
    [self.btnContent setMessageFrame:messageFrame];
    if (message.messageType == EChatMessageTypeVoice){
        self.labelVoiceTime.text = message.strVoiceTime;
    }
 
}

- (void)chatMessageContentButtonDeleteMessage:(ChatMessage *)message{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessageCellDidDeleteMessage:message:)]) {
        [self.delegate chatMessageCellDidDeleteMessage:self message:message];
    }
}


@end



