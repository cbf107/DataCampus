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
@property (nonatomic, copy) NSString *iId; //	活动编码	String
@property (nonatomic, copy) NSString *sName; //	活动名称	String
@property (nonatomic, copy) NSString *sImgPath; //	活动图片地址	String
@property (nonatomic, copy) NSString *sUrl; //	活动内容地址	String
@end

// ActiveInfos bean
@protocol ActiveInfos
@end

@interface ActiveInfos : JSONModel
@property (nonatomic, retain) NSArray<ActiveInfo> *tActive;
@end