//
//  ImageAddView.m
//  WanDa
//
//  Created by coreyfu on 15/8/10.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ImageAddView.h"
#import "UIImage+Extended.h"

#define IMG_COUNT   4
#define IMG_MARGIN   10

@interface ImageAddView() {
    NSInteger mSelectIndex;
    UIImagePickerController *imagePicker1;
    UIImagePickerController *imagePicker2;
    UIViewController *mParentViewController;
}

@end

@implementation ImageAddView
- (void)awakeFromNib {
    [self CustomInit];
}

- (void)CustomInit {
    _mImageArray = [[NSMutableArray alloc] init];
    _mImageDataArray = [[NSMutableArray alloc] init];
    _mImageViewArray = [[NSMutableArray alloc] init];
    int imgWidth = (self.frame.size.width - (IMG_COUNT+1)*IMG_MARGIN)/IMG_COUNT;
    int imgHeight = imgWidth;// = self.frame.size.height - IMG_MARGIN*2;
    for (int i=0; i<IMG_COUNT; i++) {
        CGRect rect = CGRectMake((IMG_MARGIN+imgWidth)*i+IMG_MARGIN, IMG_MARGIN, imgWidth, imgHeight);
        UIButton *btn = [[UIButton alloc]initWithFrame:rect];
        [btn setTag:i];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_mImageViewArray addObject:btn];
        [self addSubview:btn];
    }
    
    [self refreashUI];
}

- (void)refreashUI{
    for (int i=0; i<IMG_COUNT; i++) {
        UIButton *imgView = _mImageViewArray[i];
        if (i < _mImageArray.count) {
            [imgView setHidden:NO];
            [imgView setBackgroundImage:_mImageArray[i] forState:UIControlStateNormal];
        } else if (i == _mImageArray.count) {
            [imgView setHidden:NO]; // 设置默认添加图标
            [imgView setBackgroundImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
        } else {
            [imgView setHidden:YES];
            [imgView setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }
}

-(IBAction)btnAction:(id)sender {
    mSelectIndex = [sender tag];
    
    if (nil == mParentViewController) {
        for (UIView* next = [self superview]; next; next = next.superview) {
            UIResponder* nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                mParentViewController = (UIViewController*)nextResponder;
                break;
            }
        }
    }
    
    if (mSelectIndex>=0 && mSelectIndex<_mImageArray.count) {
        // delete
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil] show];
    } else {
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
            
        [action showInView:mParentViewController.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        //系统相册
        imagePicker1 = [[UIImagePickerController alloc]init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [imagePicker1 setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imagePicker1 setDelegate:self];
            [imagePicker1 setAllowsEditing:NO];
            [mParentViewController presentViewController:imagePicker1 animated:YES completion:nil];
        }
    }else if (buttonIndex == 1){
        //系统相机
        imagePicker2 = [[UIImagePickerController alloc]init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [imagePicker2 setSourceType:UIImagePickerControllerSourceTypeCamera];
            [imagePicker2 setDelegate:self];
            [imagePicker2 setAllowsEditing:YES];
            [mParentViewController presentViewController:imagePicker2 animated:YES completion:nil];
        }
    }
}

//点击相册中的图片 货照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSInteger dataIndex = mSelectIndex;
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //UIButton *tempButton = [_mImageViewArray objectAtIndex:dataIndex];
    
    //[tempButton setImage:image forState:UIControlStateNormal];
    
    UIImage *image1 = [UIImage imageWithImageSimple:image scaledToSize:CGSizeMake(320, 568)];
    NSData *base64 = UIImageJPEGRepresentation(image1, 0.1);
    
    // need add prefix
    if (_mImageDataArray.count > dataIndex) {
        [_mImageArray replaceObjectAtIndex:dataIndex withObject:image];
        [_mImageDataArray replaceObjectAtIndex:dataIndex withObject:base64];
    } else {
        [_mImageArray addObject:image];
        [_mImageDataArray addObject:base64];
    }
    
    [self refreashUI];
    
    if (picker == imagePicker2) {
        //图片存入相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    [mParentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // do delete
    if (buttonIndex > 0) {
        if (_mImageDataArray.count > mSelectIndex) {
            [_mImageArray removeObjectAtIndex:mSelectIndex];
            [_mImageDataArray removeObjectAtIndex:mSelectIndex];
        }
        
        [self refreashUI];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
