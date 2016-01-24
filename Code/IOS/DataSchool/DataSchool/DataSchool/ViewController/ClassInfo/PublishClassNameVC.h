//
//  RelationshipVC.h
//  ZhiKu
//
//  Created by mac on 15/5/20.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassValueDelegate
- (void)passValue:(NSArray *)classNames;
@end

@interface PublishClassNameVC : UIViewController<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) NSArray *listData;
@property(strong,nonatomic)UITableView *tableView;
@property(nonatomic, retain) id<PassValueDelegate> passDelegate;
@property (nonatomic, copy)NSArray *checkedName;
@end
