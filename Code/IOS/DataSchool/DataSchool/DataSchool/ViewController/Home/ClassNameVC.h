//
//  RelationshipVC.h
//  ZhiKu
//
//  Created by mac on 15/5/20.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassNameVC : UIViewController<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

//@property (retain, nonatomic) NewFriendss* mNewFriends;
//@property (nonatomic, copy)NSMutableArray *mMsgArray;
//@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property(strong,nonatomic) NSArray *listData;
@property(strong,nonatomic)UITableView *tableView;

@end
