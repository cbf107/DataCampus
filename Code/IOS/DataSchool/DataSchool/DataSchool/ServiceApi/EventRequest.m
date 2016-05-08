//
//  CleanRequest.m
//  WanDaCloud
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "EventRequest.h"
#import "ClassNotice.h"
#import "EventType.h"

@implementation EventSendRequest
- (NSString *)requestUrl {
    return kApiSendEvent;
}

- (id)requestParameters {
    return @{@"Content":self.Content?:[NSNull null],
             @"Type":self.Type?:[NSNull null],
             @"Imgs":[self makeImages],
             @"CreateUserRefid":self.CreateUserRefid?:[NSNull null]};

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


//GetEventTypeRequest
@implementation GetEventTypeRequest
- (NSString *)requestUrl {
    return kApiGetEventType;
}

- (id)requestParameters {
    return @{};
}

- (id)parseResult {
    //return (NSArray *)self.responseBodyJSON;
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSArray *list = (NSArray *)self.responseBodyJSON;
    for(int i = 0; i<list.count; i++){
        [data addObject:[[EventType alloc] initWithDictionary:list[i] error:nil]];
    }
    
    return data;
    
}
@end

//GetEventHistory
@implementation GetEventHistory
- (NSString *)requestUrl {
    return kApiGetEventHistory;
}

- (id)requestParameters {
    return @{};
}

- (id)parseResult {
    return self.responseBodyJSON;    
}
@end
