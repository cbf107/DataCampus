//
//  TabHomeCollCell.h
//  WanDaCloud
//
//  Created by mac on 15/8/28.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveInfo.h"
#import "InfiniteScrollContainer.h"
#import "SchoolNews.h"

@interface TabHomeImgScrollCell : UITableViewCell<InfiniteScrollContainerDelegate, InfiniteScrollContainerDataSource>
-(void)setInfo:(NSArray*) activeInfoArr;

@end


@interface TabHomeActiveCell : UITableViewCell
-(void)setInfo:(School_News*) activeInfo;
@end