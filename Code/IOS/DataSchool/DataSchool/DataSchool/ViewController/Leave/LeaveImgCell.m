//
//  ConfirmOrderBookCell.m
//
//  Created by coreyfu on 14-9-15.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//
#import "LeaveImgCell.h"
#import "UIImage+Extended.h"
#import "Base64.h"

@implementation LeaveImgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    

    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    _mImageBtn1.tag = 500;
    _mImageBtn2.tag = 501;
    _mImageBtn3.tag = 502;
    [_mImageBtn1 addTarget:self action:@selector(clickImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mImageBtn2 addTarget:self action:@selector(clickImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mImageBtn3 addTarget:self action:@selector(clickImageButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _mImageDelBtn1.tag = 500;
    _mImageDelBtn2.tag = 501;
    _mImageDelBtn3.tag = 502;
    [_mImageDelBtn1 addTarget:self action:@selector(clickImageDelButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mImageDelBtn2 addTarget:self action:@selector(clickImageDelButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mImageDelBtn3 addTarget:self action:@selector(clickImageDelButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _mImageArray = [[NSMutableArray alloc]init];
    _mImageDataArray = [[NSMutableArray alloc]init];
    _mImageViewArray = [[NSMutableArray alloc] initWithObjects:_mImageBtn1, _mImageBtn2, _mImageBtn3, nil];
    _mImageDelViewArray = [[NSMutableArray alloc] initWithObjects:_mImageDelBtn1, _mImageDelBtn2, _mImageDelBtn3, nil];
    
    [self updataImageRegionUI];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-----------------------删除图片----------------
- (void)clickImageDelButton:(UIButton *)btn{
    NSInteger index = btn.tag - 500;
    if (_mImageDataArray.count > index) {
        [_mImageArray removeObjectAtIndex:index];
        [_mImageDataArray removeObjectAtIndex:index];
    }
    
    [self updataImageRegionUI];
}

- (void) updataImageRegionUI{
    for (int i=0; i<3; i++) {
        if (i<_mImageDataArray.count) {
            [_mImageViewArray[i] setHidden:NO];
            [_mImageDelViewArray[i] setHidden:NO];
            [_mImageViewArray[i] setImage:_mImageArray[i] forState:UIControlStateNormal];
        } else if (i==_mImageDataArray.count) {
            [_mImageViewArray[i] setHidden:NO];
            [_mImageDelViewArray[i] setHidden:YES];
            [_mImageViewArray[i] setImage:[UIImage imageNamed:@"topic_photo_img"] forState:UIControlStateNormal];
        } else {
            [_mImageViewArray[i] setHidden:YES];
            [_mImageDelViewArray[i] setHidden:YES];
            [_mImageViewArray[i] setImage:[UIImage imageNamed:@"topic_photo_img"] forState:UIControlStateNormal];
        }
    }
}

//-----------------------添加图片----------------

- (void)clickImageButton:(UIButton *)btn{
    
    mBtnIndex = btn.tag;
    
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
    [action showInView:self.getParentVC.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //系统相册
        imagePicker1 = [[UIImagePickerController alloc]init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [imagePicker1 setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imagePicker1 setDelegate:self];
            [imagePicker1 setAllowsEditing:NO];
            [self.getParentVC presentViewController:imagePicker1 animated:YES completion:nil];
        }
    }else if (buttonIndex == 1){
        //系统相机
        imagePicker2 = [[UIImagePickerController alloc]init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [imagePicker2 setSourceType:UIImagePickerControllerSourceTypeCamera];
            [imagePicker2 setDelegate:self];
            [imagePicker2 setAllowsEditing:YES];
            [self.getParentVC presentViewController:imagePicker2 animated:YES completion:nil];
        }
    }
}

//点击相册中的图片 货照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSInteger dataIndex = mBtnIndex - 500;
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //UIButton *tempButton = [_mImageViewArray objectAtIndex:dataIndex];
    
    //[tempButton setImage:image forState:UIControlStateNormal];
    
    UIImage *image1 = [UIImage imageWithImageSimple:image scaledToSize:CGSizeMake(320, 568)];
    NSString *base64 = [UIImageJPEGRepresentation(image1, 0.1) base64EncodedString];
    
    // need add prefix
    if (_mImageDataArray.count > dataIndex) {
        [_mImageArray replaceObjectAtIndex:dataIndex withObject:image];
        [_mImageDataArray replaceObjectAtIndex:dataIndex withObject:[@"data:image/jpg;" stringByAppendingString:base64]];
    } else {
        [_mImageArray addObject:image];
        [_mImageDataArray addObject:[@"data:image/jpg;base64," stringByAppendingString:base64]];
    }
    
    [self updataImageRegionUI];
    
    if (picker == imagePicker2) {
        //图片存入相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    [self.getParentVC dismissViewControllerAnimated:YES completion:nil];
}

@end
