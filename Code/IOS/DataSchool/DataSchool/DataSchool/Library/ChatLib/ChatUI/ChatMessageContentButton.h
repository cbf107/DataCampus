//
//  ChatMessageContentButton.h
//  BloodSugarForDoc
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import "ChatMessage.h"
#import "ChatMessageFrame.h"


@protocol ChatMessageContentButtonDelegate <NSObject>
@optional
- (void)chatMessageContentButtonDeleteMessage:(ChatMessage *)message;
@end

@interface ChatMessageContentButton : UIButton
@property (nonatomic,strong) ChatMessageFrame *messageFrame;
@property (nonatomic) BOOL enableLongPress;

@property (nonatomic, weak) id<ChatMessageContentButtonDelegate>delegate;

@end
