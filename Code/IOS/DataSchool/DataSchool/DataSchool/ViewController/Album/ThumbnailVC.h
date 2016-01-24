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
#import "AlbumRequest.h"

@interface ThumbnailVC : UIViewController <UINavigationControllerDelegate, UICollectionViewDataSource,
UICollectionViewDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate>{
    UIImagePickerController *imagePicker1;
    UIImagePickerController *imagePicker2;
}


@property (weak, nonatomic) IBOutlet RefreshCollectionView* mCollectionView;

@property (nonatomic, retain)GetThumbnailRequest *pullRequest;
@property (nonatomic, copy)NSString *mImgData;

@property (nonatomic, copy)NSString *sAlbumRefId;
//collectionView将来静止可见的区域，同时也是标识CollectionView当前是正在被用户拖拽还是退拽完毕正在减速
@property (nonatomic, assign) NSValue *targetRect;

@end
