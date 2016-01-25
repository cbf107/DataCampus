//
//  CleanRequest.m
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "NoticeRequest.h"
#import "ClassNotice.h"

@implementation SendNoticeRequest
- (NSString *)requestUrl {
    return kApiSendNotice;
}

- (id)requestParameters {
    return @{@"Title":self.Title?:[NSNull null],
             @"Content":self.Content?:[NSNull null],
             @"ClassName":[self makeClassNames],
             @"Type":self.Type?:[NSNull null],
             @"Imgs":[self makeImages],
             @"CreateUserRefid":self.CreateUserRefid?:[NSNull null]};

}

-(id)makeClassNames{
    if (nil != self.ClassName) {
        return self.ClassName;
    }
    return [NSNull null];
}

- (id)makeImages {
    if (nil != self.Imgs) {
        switch (self.Imgs.count) {
            case 0:
                return @[];
            case 1:
                return @[self.Imgs[0]];
            case 2:
                return @[self.Imgs[0],self.Imgs[1]];
            case 3:
                return @[self.Imgs[0],self.Imgs[1],self.Imgs[2]];
            
            case 4:
                return @[self.Imgs[0],self.Imgs[1],self.Imgs[2],self.Imgs[3]];
            case 5:
                return @[self.Imgs[0],self.Imgs[1],self.Imgs[2],self.Imgs[3],self.Imgs[4]];
            case 6:
                return @[self.Imgs[0],self.Imgs[1],self.Imgs[2],self.Imgs[3],self.Imgs[4],self.Imgs[5]];
            default:
                break;
        }
    }
    return [NSNull null];
}

- (id)parseResult {
    return self.responseBodyJSON;
}
@end




@implementation GetClassNoticeRequest
- (NSString *)requestUrl {
    return kApiGetClassNotice;
}

- (id)requestParameters {
    return @{@"Type":self.Type?:[NSNull null],
             @"className":self.className?:[NSNull null],
             @"start":@(self.pageStart),
             @"length":@(self.pageLength)};

}

- (id)parseResult {
    /*id result = self.responseBodyJSON;
    if ([result isKindOfClass:[NSDictionary class]]) {
        ClassNotices *classNotices = [[ClassNotices alloc] initWithDictionary:result error:nil];
        return classNotices;
    }
    
    return nil;*/
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSArray *list = (NSArray *)self.responseBodyJSON;
    for(int i = 0; i<list.count; i++){
        [data addObject:[[ClassNotice alloc] initWithDictionary:list[i] error:nil]];
    }
    
    return data;
}
@end



@implementation DeleteNoticeRequest
- (NSString *)requestUrl {
    return kApiDeleteNotice;
}

- (id)requestParameters {
    return @{@"NoticeRefId":self.NoticeRefId?:[NSNull null]};
    
}

- (id)parseResult {
    return self.responseBodyJSON;
}
@end

