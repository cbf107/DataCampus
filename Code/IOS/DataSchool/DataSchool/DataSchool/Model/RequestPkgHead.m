//
//  RequestPkgHead.m
//  WanDa
//
//  Created by coreyfu on 15/7/21.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "RequestPkgHead.h"
#import <AdSupport/AdSupport.h>

#define DEV_KEY @"TFZFXAPI"

@implementation RequestPkgHead
static RequestPkgHead *instance;

+ (RequestPkgHead *)instance {
    if (!instance) {
        instance = [[RequestPkgHead alloc] init];
    }
    return instance;
}
@end
