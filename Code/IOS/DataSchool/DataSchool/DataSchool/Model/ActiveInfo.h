//
//  ActiveInfo.h
//  WanDaCloud
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

//活动
@protocol ActiveInfo
@end

@interface ActiveInfo : JSONModel
/*@property (nonatomic, copy) NSString *iId; //	活动编码	String
@property (nonatomic, copy) NSString *sName; //	活动名称	String
@property (nonatomic, copy) NSString *sImgPath; //	活动图片地址	String
@property (nonatomic, copy) NSString *sUrl; //	活动内容地址	String*/
@property (nonatomic, copy) NSString *RefId;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *Content;
@property (nonatomic, copy) NSString *InsertTime;
@property (nonatomic, copy) NSString *Cover;
@property (nonatomic, copy) NSString *CreateUserRefId;
@property (nonatomic, copy) NSString *AudioRefId;
@property (nonatomic, copy) NSString *PublicTime;
@property (nonatomic, copy) NSString *AuditTime;
@property (nonatomic, copy) NSString *Audit;
@property (nonatomic, copy) NSString *Url;
@property (nonatomic, assign) int IsReply;
@property (nonatomic, assign) int IsAuto;
@property (nonatomic, assign) int State;
@property (nonatomic, assign) int Sort;

@end

// ActiveInfos bean
@protocol ActiveInfos
@end

@interface ActiveInfos : JSONModel
@property (nonatomic, retain) NSArray<ActiveInfo> *tActive;
@end