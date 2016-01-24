//
//  ViewController.m
//  ViewDeckExample
//
//  Copyright (C) 2011-2015, ViewDeck
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "UploadImageVC.h"
#import "UIImage+Extended.h"
#import "Base64.h"

@implementation UploadImageVC

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStyleBordered target:self action:@selector(uploadAction)];
    
    [self.mImageBtn addTarget:self action:@selector(clickImageButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mImageBtn setImage:[UIImage imageNamed:@"topic_photo_img"] forState:UIControlStateNormal];
    
    self.mChooseClassLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *classTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(classTouchUpInside:)];
    [self.mChooseClassLable addGestureRecognizer:classTapGestureRecognizer];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)uploadAction{
    
}

- (void)clickImageButton:(UIButton *)btn{
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //系统相册
        imagePicker1 = [[UIImagePickerController alloc]init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [imagePicker1 setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imagePicker1 setDelegate:self];
            [imagePicker1 setAllowsEditing:NO];
            [self presentViewController:imagePicker1 animated:YES completion:nil];
        }
    }else if (buttonIndex == 1){
        //系统相机
        imagePicker2 = [[UIImagePickerController alloc]init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [imagePicker2 setSourceType:UIImagePickerControllerSourceTypeCamera];
            [imagePicker2 setDelegate:self];
            [imagePicker2 setAllowsEditing:YES];
            [self presentViewController:imagePicker2 animated:YES completion:nil];
        }
    }
}

//点击相册中的图片 货照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *image1 = [UIImage imageWithImageSimple:image scaledToSize:CGSizeMake(320, 560)];
    NSString *base64 = [UIImageJPEGRepresentation(image1, 0.1) base64EncodedString];
    
    _mImgData = [@"data:image/jpg;base64," stringByAppendingString:base64];
    
    [_mImageBtn setImage:image forState:UIControlStateNormal];
    
    if (picker == imagePicker2) {
        //图片存入相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)classTouchUpInside:(UITapGestureRecognizer *)recognizer{
    UploadClassFolderVC *className = [[UploadClassFolderVC alloc] init];
    className.passDelegate = self;
    
    if(_classNames.count > 0){
        className.classNames = _classNames;
    }else{
        UserInfo *userInfo = [UserManager currentUser];
        NSString *currentClassName = userInfo.CurrentUserClass;
        
        NSArray *data = [[NSArray alloc] initWithObjects:currentClassName, nil];
        className.classNames = data;
    }
    
    [self.navigationController pushViewController:className animated:YES];
}

//PassValueDelegate
- (void)passValue:(NSArray *)classNames{
    _classNames = classNames;
    
    NSMutableString *strName = [[NSMutableString alloc] init];
    for(int i = 0; i<classNames.count; i++){
        if (i > 0) {
            [strName appendString:@"，"];
        }
        
        NSString *name = classNames[i];
        [strName appendString:name];
    }
    _mChooseClassLable.text = [NSString stringWithString:strName];
}

@end
