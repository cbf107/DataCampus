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

#import "InfoPublishVC.h"
#import "UIImage+Extended.h"
#import "Base64.h"
#import "NoticeRequest.h"
#import "SysRequest.h"
#import "ClassNotice.h"

@implementation InfoPublishVC

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
    
    _mImageBtn1.tag = 500;
    _mImageBtn2.tag = 501;
    _mImageBtn3.tag = 502;
    _mImageBtn4.tag = 503;
    _mImageBtn5.tag = 504;
    _mImageBtn6.tag = 505;

    [_mImageBtn1 addTarget:self action:@selector(clickImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mImageBtn2 addTarget:self action:@selector(clickImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mImageBtn3 addTarget:self action:@selector(clickImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mImageBtn4 addTarget:self action:@selector(clickImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mImageBtn5 addTarget:self action:@selector(clickImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mImageBtn6 addTarget:self action:@selector(clickImageButton:) forControlEvents:UIControlEventTouchUpInside];

    _mImageDelBtn1.tag = 500;
    _mImageDelBtn2.tag = 501;
    _mImageDelBtn3.tag = 502;
    _mImageDelBtn4.tag = 503;
    _mImageDelBtn5.tag = 504;
    _mImageDelBtn6.tag = 505;

    [_mImageDelBtn1 addTarget:self action:@selector(clickImageDelButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mImageDelBtn2 addTarget:self action:@selector(clickImageDelButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mImageDelBtn3 addTarget:self action:@selector(clickImageDelButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mImageDelBtn4 addTarget:self action:@selector(clickImageDelButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mImageDelBtn5 addTarget:self action:@selector(clickImageDelButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mImageDelBtn6 addTarget:self action:@selector(clickImageDelButton:) forControlEvents:UIControlEventTouchUpInside];

    UserInfo *info = [UserManager currentUser];
    
    if (![info.UserType isEqualToString:@"教师"]) {
        _mPublishBtn.hidden = YES;
    }
    
    _mImageArray = [[NSMutableArray alloc]init];
    _mImageDataArray = [[NSMutableArray alloc]init];
    _mImageViewArray = [[NSMutableArray alloc] initWithObjects:_mImageBtn1, _mImageBtn2, _mImageBtn3, _mImageBtn4, _mImageBtn5, _mImageBtn6, nil];
    _mImageDelViewArray = [[NSMutableArray alloc] initWithObjects:_mImageDelBtn1, _mImageDelBtn2, _mImageDelBtn3, _mImageDelBtn4, _mImageDelBtn5, _mImageDelBtn6, nil];
    
    _mTextContent.tag = 100;
    _mTitleTextContent.tag = 101;
    [self updataImageRegionUI];

    self.mChooseTypeLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *typeTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeTouchUpInside:)];
    [self.mChooseTypeLable addGestureRecognizer:typeTapGestureRecognizer];
    
    self.mChooseClassLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *classTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(classTouchUpInside:)];
    [self.mChooseClassLable addGestureRecognizer:classTapGestureRecognizer];
    
    UserInfo *userInfo = [UserManager currentUser];
    _mChooseClassLable.text = userInfo.CurrentUserClass;
    _classNames = [NSArray arrayWithObjects:userInfo.CurrentUserClass, nil];
    
    _typeArray = [[NSMutableArray alloc] init];
    GetUserNotifyTypeRequest *request = [[GetUserNotifyTypeRequest alloc] init];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
        NSArray *type = request.parseResult;
        for (int i = 0; i < type.count; i++) {
            [_typeArray addObject:((ClassNoticeType *)type[i]).Type];
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *err) {
        [SVProgressHUD dismiss];
        _typeArray = nil;
    }];
}

-(void)typeTouchUpInside:(UITapGestureRecognizer *)recognizer{
    [self showPickView];
}

-(void)classTouchUpInside:(UITapGestureRecognizer *)recognizer{
    PublishClassNameVC *className = [[PublishClassNameVC alloc] init];
    className.passDelegate = self;
    
    if(_classNames.count > 0){
        className.checkedName = _classNames;
    }else{
        UserInfo *userInfo = [UserManager currentUser];
        NSString *currentClassName = userInfo.CurrentUserClass;
        
        NSArray *data = [[NSArray alloc] initWithObjects:currentClassName, nil];
        className.checkedName = data;
    }
    
    [self.navigationController pushViewController:className animated:YES];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_mTextContent resignFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_mPushPickview) {
        [_mPushPickview remove];
        _mPushPickview = nil;
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
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
    for (int i=0; i<6; i++) {
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.tag == 100) {
        if (![text isEqualToString:@""]){
            _mPlaceholderLabel.hidden = YES;
        }
        
        if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
            _mPlaceholderLabel.hidden = NO;
        }
    }
    
    if (textView.tag == 101) {
        if (![text isEqualToString:@""]){
            _mTitlePlaceholderLabel.hidden = YES;
        }
        
        if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
            _mTitlePlaceholderLabel.hidden = NO;
        }
    }

    return YES;
    
}

- (IBAction)publishAction:(id)sender {
    NSString *errMsg = nil;
    
    /*if (nil == _mTextContent.text || _mTextContent.text.length == 0) {
        errMsg = @"请填写话题类容";
    } else if (_mTextContent.text.length > 140) {
        errMsg = @"话题内容不能超过140字";
    } else if (_mImageDataArray.count == 0) {
        errMsg = @"请选择话题图片";
    }*/
    
    if (errMsg) {
        [[[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    } else {
        SendNoticeRequest *request = [[SendNoticeRequest alloc] init];
        request.Title = _mTitleTextContent.text;
        request.Content = _mTextContent.text;
        request.Imgs = _mImageDataArray;
        request.Type = _mType;
        request.ClassName = _classNames;
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
            [SVProgressHUD dismiss];
            [_mTextContent resignFirstResponder];
            [[[UIAlertView alloc] initWithTitle:nil message:@"发布成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *err) {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:@"失败" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
    }
    
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    NSLog(@"toobar done");
    _mType = resultString;
    
    _mChooseTypeLable.text = _mType;
    _mChooseTypeLable.textColor = [UIColor blackColor];
}


- (void) showPickView {
    if (_typeArray == nil) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"获取类型失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }else{
        _mPushPickview=[[ZHPickView alloc] initPickviewWithArray:_typeArray isHaveNavControler:NO];
        _mPushPickview.delegate=self;
        [_mPushPickview show];

    }
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
