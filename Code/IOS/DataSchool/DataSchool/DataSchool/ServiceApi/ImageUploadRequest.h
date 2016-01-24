//
//  ImageUploadRequest.h
//  WanDa
//
//  Created by coreyfu on 15/8/13.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageUploadRequest: NSObject

-(void)uploadImages:(NSArray *) images success:(void (^)(id data))success fail:(void (^)())fail;

@end
