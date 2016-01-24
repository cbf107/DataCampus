//
//  MessageInfo.h
//  ZhiKu
//
//  Created by mac on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "JSONModel.h"
#import "AlbumFolder.h"

@protocol FolderInfo
@end

@interface FolderInfo : JSONModel
@property (nonatomic, copy)NSString *ClassName;
@property (nonatomic, copy)NSArray<AlbumFolder> *AlbumFolder;
@end

@protocol FolderInfos
@end

@interface FolderInfos : JSONModel
@property (nonatomic, copy)NSArray<FolderInfo> *FolderInfos;
@end
