//
//  AlbumViewController.h
//  NewProject
//
//  Created by 学鸿 张 on 13-11-29.
//  Copyright (c) 2013年 Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumRequest.h"

@interface AlbumViewController : UIViewController<UINavigationControllerDelegate,
UITableViewDelegate,
UITableViewDataSource,
UIActionSheetDelegate,
UIImagePickerControllerDelegate>{
    UIImagePickerController *imagePicker1;
    UIImagePickerController *imagePicker2;
}


@property (weak, nonatomic) IBOutlet RefreshTableView* mTableView;

@property (nonatomic, retain)GetAlbumFolderRequest *pullRequest;

@end
