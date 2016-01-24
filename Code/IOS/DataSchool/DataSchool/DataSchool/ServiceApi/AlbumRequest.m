//
//  CleanRequest.m
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "AlbumRequest.h"
#import "AlbumFolder.h"
#import "ThumbnailInfo.h"
#import "FolderInfo.h"

//获取相册文件夹列表
@implementation GetAlbumFolderRequest
- (NSString *)requestUrl {
    return kApiGetAlbumFolderList;
}

- (id)requestParameters {
    return @{@"ClassName":self.CurrentClassName?:[NSNull null],
             @"start":@(self.pageStart),
             @"length":@(self.pageLength)};
    
}

- (id)parseResult {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSArray *list = (NSArray *)self.responseBodyJSON;
    for(int i = 0; i<list.count; i++){
        [data addObject:[[AlbumFolder alloc] initWithDictionary:list[i] error:nil]];
    }
    
    return data;
}
@end


//获取相册缩略图
@implementation GetThumbnailRequest
- (NSString *)requestUrl {
    return kApiGetThumbnailList;
}

- (id)requestParameters {
    return @{@"AlbumRefId":self.AlbumRefId?:[NSNull null],
             @"start":@(self.pageStart),
             @"length":@(self.pageLength)};

}

- (id)parseResult {
    /*id result = self.responseBodyJSON;
    if ([result isKindOfClass:[NSDictionary class]]) {
        ThumbnailInfos *thumbnailInfos = [[ThumbnailInfos alloc] initWithDictionary:result error:nil];
        return thumbnailInfos;
    }
    
    return nil;*/
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSArray *list = (NSArray *)self.responseBodyJSON;
    for(int i = 0; i<list.count; i++){
        [data addObject:[[ThumbnailInfo alloc] initWithDictionary:list[i] error:nil]];
    }
    
    return data;

}
@end

//获取所有可用的相册目录
@implementation GetUploadFolderList
- (NSString *)requestUrl {
    return kApiGetUploadFolderList;
}

- (id)requestParameters {
    return @{};
}

- (id)parseResult {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSArray *list = (NSArray *)self.responseBodyJSON;
    for(int i = 0; i<list.count; i++){
        [data addObject:[[FolderInfo alloc] initWithDictionary:list[i] error:nil]];
    }
    
    return data;

}
@end

//上传图片
@implementation UploadImage
- (NSString *)requestUrl {
    return kApiUploadImage;
}

- (id)requestParameters {
    return @{@"Img":self.Img?:[NSNull null],
             @"Title":self.Title?:[NSNull null],
             @"Folders":[self getFolderNames]
             };
}

- (id)parseResult {
    return self.responseBodyJSON;
}

-(id)getFolderNames{
    if (nil != self.Folders) {
        return self.Folders;
    }
    return [NSNull null];
}

@end
