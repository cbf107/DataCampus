//
//  ViewController.h
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


#import <UIKit/UIKit.h>
#import "ZHPickView.h"

@interface EventSubmitVC : UIViewController<UIPickerViewDataSource,
UIPickerViewDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIAlertViewDelegate,
UITextViewDelegate,
ZHPickViewDelegate>{
    NSInteger mBtnIndex;
    
    UIImagePickerController *imagePicker1;
    UIImagePickerController *imagePicker2;
}

@property (nonatomic, retain) IBOutlet UILabel*  mChooseTypeLable;
@property (nonatomic, retain) ZHPickView *mPushPickview;

@property (weak, nonatomic) IBOutlet UILabel *mPlaceholderLabel;
@property (weak, nonatomic) IBOutlet UITextView *mTextContent;

@property (weak, nonatomic) IBOutlet UIButton *mImageBtn1;
@property (weak, nonatomic) IBOutlet UIButton *mImageBtn2;
@property (weak, nonatomic) IBOutlet UIButton *mImageBtn3;
@property (weak, nonatomic) IBOutlet UIButton *mImageBtn4;
@property (weak, nonatomic) IBOutlet UIButton *mImageBtn5;
@property (weak, nonatomic) IBOutlet UIButton *mImageBtn6;

@property (weak, nonatomic) IBOutlet UIButton *mImageDelBtn1;
@property (weak, nonatomic) IBOutlet UIButton *mImageDelBtn2;
@property (weak, nonatomic) IBOutlet UIButton *mImageDelBtn3;
@property (weak, nonatomic) IBOutlet UIButton *mImageDelBtn4;
@property (weak, nonatomic) IBOutlet UIButton *mImageDelBtn5;
@property (weak, nonatomic) IBOutlet UIButton *mImageDelBtn6;

@property (nonatomic, strong) NSMutableArray *mImageViewArray;
@property (nonatomic, strong) NSMutableArray *mImageDelViewArray;
@property (nonatomic, strong) NSMutableArray *mImageArray;
@property (nonatomic, strong) NSMutableArray *mImageDataArray;

@property (nonatomic, copy)NSString *mType;
@property (nonatomic, retain)NSMutableArray *typeArray;

@property (nonatomic, copy)NSString *mUrl;

@end
