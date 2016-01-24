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

#import "ThumbnailVC.h"
#import "ThumbnailInfo.h"
#import "IIViewDeckController.h"
#import "ThumbnailCollectionCell.h"
#import "PhotoBroswerVC.h"
#import "ScanViewController.h"
#import "UIImage+Extended.h"
#import "Base64.h"
#import "UploadClassFolderVC.h"

@implementation ThumbnailVC

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"拍摄" style:UIBarButtonItemStyleBordered target:self action:@selector(setupCamera)];
    
    //self.mCollectionView.tableFooterView = [[UIView alloc]init];
    /*self.mCollectionView.refreshStatusViewBlock = ^(RefreshTableViewStatus status){
        if (status == RefreshTableViewStatusNoResult) {
            //self.mCollectionView.tableHeaderView = [[RefreshStatusView alloc] initWithImageName:@"message_img" text:@"还没有消息哦"];
        }else {
            //self.mCollectionView.tableHeaderView = [RefreshStatusView statusViewWithStatus:status];
        }
    };*/
    [self setupHeader];//下拉刷新

}

- (void)setupHeader
{
    if (!self.pullRequest) {
        self.pullRequest = [[GetThumbnailRequest alloc] initWithStart:0 length:kPageCount];
        self.mCollectionView.request = self.pullRequest;
        
        self.pullRequest.AlbumRefId = self.sAlbumRefId;
        [self.mCollectionView addHeader];
        
    }
    [self.mCollectionView headerBeginRefreshing];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setup camera
-(void)setupCamera{
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
    
    if (picker == imagePicker2) {
        //图片存入相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        UploadClassFolderVC *className = [[UploadClassFolderVC alloc] init];
        className.mImg = _mImgData;
        className.folderID = self.sAlbumRefId;
        [self.navigationController pushViewController:className animated:YES];
    }];
    
}


#pragma mark - collectionView
//集合代理-每一部分数据项
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (nil != [((RefreshCollectionView*) collectionView) dataArray]) {
        return [[((RefreshCollectionView*) collectionView) dataArray] count];
    } else {
        return 0;
    }
}


//Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ThumbnailCollectionCell";
    ThumbnailCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell != nil) {
        ThumbnailInfo *info = [[(RefreshCollectionView *)collectionView dataArray] objectAtIndex:indexPath.row];
        
        [cell setInfo:info];
        
        cell.mIndexPath = indexPath;
    }
    
    return cell;


    //[self loadImageForCell:cell atIndexPath:indexPath];
    //return cell;

}

//代理－选择行的触发事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击
    //__weak typeof(self) weakSelf=self;
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeModal index:indexPath.row photoModelBlock:^NSArray *{
        NSMutableArray *modelsM = [[NSMutableArray alloc] init];
        
        NSUInteger count = [(RefreshCollectionView *)collectionView dataArray].count;
        for (NSUInteger i = 0; i < count; i++) {
            ThumbnailInfo *info = [[(RefreshCollectionView *)collectionView dataArray] objectAtIndex:i];
            //[_data addObject:info.ImageURL];
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.title = [NSString stringWithFormat:@"这是标题%@",@(i+1)];
            pbModel.desc = @"";
            pbModel.image_HD_U = info.ImageURL;
            
            //源frame
            UICollectionViewCell *cell = [_mCollectionView cellForItemAtIndexPath:indexPath];
            UIImageView *imageV = ((ThumbnailCollectionCell *)cell).mThumbnail;
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];

        }
        
        return modelsM;
        //NSArray *networkImages = [NSArray arrayWithArray:_data];
        
        /*NSArray *networkImages=@[
                                 @"http://www.netbian.com/d/file/20150519/f2897426d8747f2704f3d1e4c2e33fc2.jpg",
                                 @"http://www.netbian.com/d/file/20130502/701d50ab1c8ca5b5a7515b0098b7c3f3.jpg",
                                 @"http://www.netbian.com/d/file/20110418/48d30d13ae088fd80fde8b4f6f4e73f9.jpg",
                                 @"http://www.netbian.com/d/file/20150318/869f76bbd095942d8ca03ad4ad45fc80.jpg",
                                 @"http://www.netbian.com/d/file/20110424/b69ac12af595efc2473a93bc26c276b2.jpg",
                                 
                                 @"http://www.netbian.com/d/file/20140522/3e939daa0343d438195b710902590ea0.jpg",
                                 
                                 @"http://www.netbian.com/d/file/20141018/7ccbfeb9f47a729ffd6ac45115a647a3.jpg",
                                 
                                 @"http://www.netbian.com/d/file/20140724/fefe4f48b5563da35ff3e5b6aa091af4.jpg",
                                 
                                 @"http://www.netbian.com/d/file/20140529/95e170155a843061397b4bbcb1cefc50.jpg"
                                 ];
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        for (NSUInteger i = 0; i< networkImages.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.title = [NSString stringWithFormat:@"这是标题%@",@(i+1)];
            pbModel.desc = @"";
            pbModel.image_HD_U = networkImages[i];
            
            //源frame
            UICollectionViewCell *cell = [_mCollectionView cellForItemAtIndexPath:indexPath];
            UIImageView *imageV = ((ThumbnailCollectionCell *)cell).mThumbnail;
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;*/
    }];

}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(110, 110);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

/*#pragma mark - UIScrollview delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.targetRect = nil;
    [self loadImageForVisibleCells];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGRect targetRect = CGRectMake(targetContentOffset->x, targetContentOffset->y, scrollView.frame.size.width, scrollView.frame.size.height);
    self.targetRect = [NSValue valueWithCGRect:targetRect];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.targetRect = nil;
    [self loadImageForVisibleCells];
}

#pragma mark - Decide to Load Image For Cells
- (void)loadImageForCell:(ThumbnailCollectionCell *)cell
             atIndexPath:(NSIndexPath *)indexPath {
    // Cell的targetURLString是指派给Cell的新的图片URL，在根据Cell的DTO配置Cell时为其赋值
    NSArray *dataList = [NSArray arrayWithArray:[((RefreshCollectionView*) self.mCollectionView) dataArray]];
    
    ThumbnailInfo *thumInfo = [dataList objectAtIndex:indexPath.row];
    if (!thumInfo.ThumbnailURL) {
        return;
    }
    
    // Cell的imageURLString是Cell的当前正在显示的图片URL
    NSURL *targetURL = [NSURL URLWithString:thumInfo.ThumbnailURL];

    if (![[cell.mThumbnail sd_imageURL] isEqual:targetURL] || cell.isDisplayingPlaceholderNow) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        UICollectionViewLayoutAttributes *attr = [self.mCollectionView layoutAttributesForItemAtIndexPath:indexPath];
        CGRect cellFrame = attr.frame;
        
        BOOL shouldLoadImageForCurrentCell = YES;
        // 如果正在减速而且当前Cell的frame不在将来滑动停止后的可见区域
        
        if (self.targetRect) {
            CGRect rect = [self.targetRect CGRectValue];
            if (!!CGRectIntersectsRect(rect, cellFrame)) {
                SDImageCache *imageCache = [SDImageCache sharedImageCache];
                NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:thumInfo.ThumbnailURL]];
                if (![imageCache imageFromMemoryCacheForKey:key]) {
                    shouldLoadImageForCurrentCell = NO;
                }

            }
        }

        if (shouldLoadImageForCurrentCell) {
            [cell setInfo:thumInfo];
        }
    }
}

- (void)loadImageForVisibleCells {
    NSArray *visibleCells = [self.mCollectionView visibleCells];
    for (ThumbnailCollectionCell *cell in visibleCells) {
        NSIndexPath *indexPath = [self.mCollectionView indexPathForCell:cell];
        [self loadImageForCell:cell atIndexPath:indexPath];
    }
}*/
@end
