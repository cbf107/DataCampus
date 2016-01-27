//
//  UUMessageCell.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "ChatMessageContentButton.h"

@class ChatMessageCell;

@protocol ChatMessageCellDelegate <NSObject>
@optional
- (void)headImageDidClick:(ChatMessageCell *)cell userId:(NSString *)userId;
- (void)chatMessageCellDidDeleteMessage:(ChatMessageCell *)cell message:(ChatMessage *)message;
@end


@interface ChatMessageCell : UITableViewCell

@property (nonatomic, strong) UILabel *labelTime;
@property (nonatomic, strong) UILabel *labelVoiceTime;
@property (nonatomic, strong) UILabel *labelNum;
@property (nonatomic, strong) UIButton *btnHeadImage;
@property (nonatomic) BOOL enableLongPress;


@property (nonatomic, strong) ChatMessageFrame *messageFrame;

@property (nonatomic, weak) id<ChatMessageCellDelegate>delegate;

@end

