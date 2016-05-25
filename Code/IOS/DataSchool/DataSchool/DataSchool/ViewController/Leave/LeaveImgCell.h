//
//  ConfirmOrderBookCell.h
//  MarketEleven
//
//  Created by coreyfu on 14-9-15.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface LeaveImgCell : UITableViewCell<UIPickerViewDataSource,
UIPickerViewDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIAlertViewDelegate,
UITextViewDelegate>{
    NSInteger mBtnIndex;

    UIImagePickerController *imagePicker1;
    UIImagePickerController *imagePicker2;

}

@property (weak, nonatomic) IBOutlet UIButton *mImageBtn1;
@property (weak, nonatomic) IBOutlet UIButton *mImageBtn2;
@property (weak, nonatomic) IBOutlet UIButton *mImageBtn3;

@property (weak, nonatomic) IBOutlet UIButton *mImageDelBtn1;
@property (weak, nonatomic) IBOutlet UIButton *mImageDelBtn2;
@property (weak, nonatomic) IBOutlet UIButton *mImageDelBtn3;

@property (nonatomic, strong) NSMutableArray *mImageViewArray;
@property (nonatomic, strong) NSMutableArray *mImageDelViewArray;
@property (nonatomic, strong) NSMutableArray *mImageArray;
@property (nonatomic, strong) NSMutableArray *mImageDataArray;

@end
