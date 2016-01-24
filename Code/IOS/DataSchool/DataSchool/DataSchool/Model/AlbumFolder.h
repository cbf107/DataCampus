//
//  MessageInfo.h
//  ZhiKu
//
//  Created by mac on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "JSONModel.h"

@protocol AlbumFolder
@end

@interface AlbumFolder : JSONModel
@property (nonatomic, copy)NSString *AlbumRefId;
@property (nonatomic, copy)NSString *AlbumName;
@property (nonatomic, copy)NSString *LastUpdateTime;
@property (nonatomic, copy)NSString *CreateTime;
@property (nonatomic, copy)NSString *Thumbnail;
@property (nonatomic, copy)NSString *CreateUserRefId;
@property (nonatomic, assign)int Number;
@end

@protocol AlbumFolders
@end

@interface AlbumFolders : JSONModel
@property (nonatomic, copy)NSArray<AlbumFolder> *AlbumFolders;
@end
