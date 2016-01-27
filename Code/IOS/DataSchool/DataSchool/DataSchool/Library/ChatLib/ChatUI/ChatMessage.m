//
//  ChatMessage.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "ChatMessage.h"

@implementation ChatMessage

- (instancetype)init{
    if ((self = [super init]) != nil) {
        _fromType = EChatMessageFromOther;
        _showDate = NO;
    }
    
    return self;
}

//"08-10 晚上08:09:41.0" ->
//"昨天 上午10:09"或者"2012-08-10 凌晨07:09"
- (NSString *)changeTheDateString:(NSString *)Str
{
    NSString *subString = [Str substringWithRange:NSMakeRange(0, 19)];
    NSDate *lastDate = [NSDate dateFromString:subString withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateStr;  //年月日
    NSString *period;   //时间段
    NSString *hour;     //时
    
    if ([lastDate year]==[[NSDate date] year]) {
        NSInteger days = [NSDate daysOffsetBetweenStartDate:lastDate endDate:[NSDate date]];
        if (days <= 2) {
            dateStr = [lastDate stringYearMonthDayCompareToday];
        }else{
            dateStr = [lastDate stringMonthDay];
        }
    }else{
        dateStr = [lastDate stringYearMonthDay];
    }
    
    
    if ([lastDate hour]>=5 && [lastDate hour]<12) {
        period = @"AM";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }else if ([lastDate hour]>=12 && [lastDate hour]<=18){
        period = @"PM";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
    }else if ([lastDate hour]>18 && [lastDate hour]<=23){
        period = @"Night";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
    }else{
        period = @"Dawn";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }
    return [NSString stringWithFormat:@"%@ %@ %@:%02d",dateStr,period,hour,(int)[lastDate minute]];
}

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end
{
    if (!start) {
        self.showDate = YES;
        return;
    }
    
    NSString *subStart = [start substringWithRange:NSMakeRange(0, 19)];
    NSDate *startDate = [NSDate dateFromString:subStart withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *subEnd = [end substringWithRange:NSMakeRange(0, 19)];
    NSDate *endDate = [NSDate dateFromString:subEnd withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //这个是相隔的秒数
    NSTimeInterval timeInterval = [startDate timeIntervalSinceDate:endDate];
    
    //相距5分钟显示时间Label
    if (fabs (timeInterval) > 300) {
        self.showDate = YES;
    }else{
        self.showDate = NO;
    }
    
}
//
//- (MutilmediaMsgInfo *)makeMutilmediaMsgInfo{
//    MutilmediaMsgInfo *info = [[MutilmediaMsgInfo alloc] init];
//    info.createTime = self.strTime;
//    
//    switch (self.messageType) {
//        case EChatMessageTypePicture:
//            break;
//            
//        case EChatMessageTypeText:{
//            info.type = EReservationInfoMessageTypeText;
//            info.textConntent = self.strContent;
//            info.audioUrl = nil;
//            info.audioData = nil;
//        }
//            break;
//            
//        case EChatMessageTypeVoice:{
//            info.type = EReservationInfoMessageTypeVoice;
//            info.textConntent = nil;
//            info.audioUrl = nil;
//            info.audioData = [self.voiceAmr base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//    return info;
//}
@end
