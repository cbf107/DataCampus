//
//  MessageInfo.h
//  ZhiKu
//
//  Created by mac on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "JSONModel.h"

@protocol ThumbnailInfo
@end

@interface ThumbnailInfo : JSONModel
@property (nonatomic, copy)NSString *AlbumDetailRefId;
@property (nonatomic, copy)NSString *AlbumDetailName;
@property (nonatomic, copy)NSString *CreateTime;
@property (nonatomic, copy)NSString *CreateUserRefId;
@property (nonatomic, copy)NSString *ThumbnailURL;
@property (nonatomic, copy)NSString *ImageURL;

@end

@protocol ThumbnailInfos
@end

@interface ThumbnailInfos : JSONModel
@property (nonatomic, copy)NSArray<ThumbnailInfo> *ThumbnailInfos;
@end
