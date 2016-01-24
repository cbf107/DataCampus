//
//  CleanRequest.h
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

//获取相册文件夹列表
@interface GetAlbumFolderRequest : BaseRequest
@property (nonatomic, copy)NSString *CurrentClassName;
@end


//获取相册缩略图
@interface GetThumbnailRequest : BaseRequest
@property (nonatomic, copy)NSString *AlbumRefId;
@end


//获取所有可用的相册目录
@interface GetUploadFolderList : BaseRequest
@end


//上传图片
@interface UploadImage : BaseRequest
@property (nonatomic, copy)NSString *Img;
@property (nonatomic, copy)NSArray *Folders;
@property (nonatomic, copy)NSString *Title;

@end