//
//  ImageAddView.h
//  WanDa
//
//  Created by coreyfu on 15/8/10.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageAddView : UIView <UIActionSheetDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIAlertViewDelegate>
@property (nonatomic, retain) NSMutableArray *mImageArray;
@property (nonatomic, retain) NSMutableArray *mImageDataArray;
@property (nonatomic, retain) NSMutableArray *mImageViewArray;
@end
