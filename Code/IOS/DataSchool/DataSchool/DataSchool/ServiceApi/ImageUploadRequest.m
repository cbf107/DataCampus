//
//  ImageUploadRequest.m
//  WanDa
//
//  Created by coreyfu on 15/8/13.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ImageUploadRequest.h"

@implementation ImageUploadRequest
-(void)uploadImages:(NSArray *) images success:(void (^)(id data))success fail:(void (^)())fail {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager manager] initWithBaseURL:[NSURL URLWithString: @"http://115.28.85.127"]];
    AFHTTPRequestOperation *op = [manager POST:@"/Ajax/HandlerWD.ashx?queryState=UpHandler" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i=0; i<images.count; i++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@", str];
            NSString *fileNameFull = [NSString stringWithFormat:@"%@.jpg", str];
            
            // 上传图片，以文件流的格式
            [formData appendPartWithFileData:images[i] name:fileName fileName:fileNameFull mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation.responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail();
    }];
    
    AFHTTPResponseSerializer *rs = [AFHTTPResponseSerializer serializer];
    rs.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
    [op setResponseSerializer:rs];
    
    [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        ;
    }];
    
    [op start];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
