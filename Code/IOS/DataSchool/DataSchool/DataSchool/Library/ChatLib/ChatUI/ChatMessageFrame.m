//
//  ChatMessageFrame.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#define ChatMarginH 12       //左边距
#define ChatMarginV 12       //上边距

#define ChatPicWH 200       //图片宽高

#define ChatTimeMarginV 8  //时间文本与边框间隔

#import "ChatMessageFrame.h"
#import "ChatMessage.h"

@implementation ChatMessageFrame

- (void)setMessage:(ChatMessage *)message{
    
    _message = message;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 1、计算时间的位置
    if (_showTime){
        CGFloat timeY = _firstMessage?ChatMarginV:0;
        CGSize timeSize = [_message.strTime boundingRectWithSize:CGSizeMake(NSIntegerMax, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: ChatTimeFont} context:nil].size;

        CGFloat timeX = (screenW - timeSize.width) * 0.5;
        _timeF = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    }
    
    CGSize size = CGSizeMake(0, 0);
    if (_showName) {
        //计算name大小
        NSMutableParagraphStyle *textParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        textParagraphStyle.alignment = NSTextAlignmentCenter;
        textParagraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        
        size = [_message.strName boundingRectWithSize:CGSizeMake(NSIntegerMax, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: ChatNameFont,NSParagraphStyleAttributeName: textParagraphStyle} context:nil].size;

    }
    
    // 2、计算头像位置
    CGFloat iconX = _showName?(size.width > self.iconSize.width?(ChatMarginH + (size.width - self.iconSize.width) * 0.5):ChatMarginH):ChatMarginH;
    if (_message.fromType == EChatMessageFromMe) {
        iconX = screenW - ChatMarginH - MAX(self.iconSize.width, size.width);
    }
    CGFloat iconY = _showTime?(CGRectGetMaxY(_timeF) + ChatTimeMarginV):(_firstMessage?ChatMarginV:0);
    _iconF = CGRectMake(iconX, iconY, self.iconSize.width, self.iconSize.height);
    
    // 3、计算ID位置
    _nameF = CGRectMake(ChatMarginH, iconY + self.iconSize.height, size.width, size.height);
    
    // 4、计算内容位置
    CGFloat contentX = MAX(CGRectGetMaxX(_iconF), CGRectGetMaxX(_nameF)) + ChatMarginH;
    CGFloat contentY = iconY;
    if (_message.fromType == EChatMessageFromMe) {
        contentX = ChatMarginH;
    }
   
    //根据种类分
    CGSize contentSize;
    CGFloat maxWidth = screenW - contentX - ChatMarginH;
    if (_message.fromType == EChatMessageFromMe) {
        maxWidth = screenW - contentX - MAX(_iconF.size.width, _nameF.size.width) - ChatMarginH - ChatMarginH;
    }
    
    
    switch (_message.messageType) {
        case EChatMessageTypeText:
            contentSize = [_message.strContent boundingRectWithSize:CGSizeMake(maxWidth - ChatContentMarginLeft - ChatContentMarginRight, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: ChatContentFont} context:nil].size;
            contentSize.height += (ChatContentMarginV * 2);
            contentSize.width += (ChatContentMarginLeft + ChatContentMarginRight);

            break;
        case EChatMessageTypePicture:
            contentSize = CGSizeMake(ChatPicWH, ChatPicWH);
            break;
        case EChatMessageTypeVoice:{
            CGFloat w = 15 * _message.duration * 0.4;
            if (w < 62) w = 62;  // old is 35
            
            CGSize tSize = [_message.strVoiceTime boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: ChatVoiceTimeFont} context:nil].size;
            maxWidth -= (tSize.width + ChatVoiceMarginLeft);
            
            CGFloat h = size.height + self.iconSize.height;
            contentSize = CGSizeMake(w > maxWidth?maxWidth:w, 30);
            contentY += ((h > 30)?(h - 30) * 0.5:0);
            _voiceDurationF = CGRectMake(contentX + contentSize.width + ChatVoiceMarginLeft, contentY + (contentSize.height - tSize.height) * 0.5, tSize.width, tSize.height);
            if (_message.fromType == EChatMessageFromMe) {
                _voiceDurationF = CGRectMake(iconX - ChatMarginH - contentSize.width - tSize.width - ChatVoiceMarginLeft, contentY + (contentSize.height - tSize.height) * 0.5, tSize.width, tSize.height);
            }
        }
            break;
        default:
            break;
    }
    if (_message.fromType == EChatMessageFromMe) {
        contentX = iconX - ChatMarginH - contentSize.width;
    }
    
//    CGFloat minH = (contentSize.height > (size.height + ChatIconWH))?contentSize.height:size.height + ChatIconWH;
    
    _contentF = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);

    _cellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_nameF)) + ChatMarginV;
    
}

@end
