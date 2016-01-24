//
//  RelationshipVC.h
//  ZhiKu
//
//  Created by mac on 15/5/20.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FolderInfo.h"

@interface UploadClassFolderVC : UIViewController<UINavigationControllerDelegate,UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property(strong,nonatomic) NSArray<FolderInfo> *listData;
@property(strong,nonatomic)UITableView *tableView;

@property (nonatomic, copy)NSString *folderID;
@property (nonatomic, copy)NSString *mImg;
@property (nonatomic, retain)NSMutableArray *data;
@end
