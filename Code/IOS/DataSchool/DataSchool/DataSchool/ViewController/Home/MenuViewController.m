//
//  LeftViewController.m
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


#import "MenuViewController.h"
#import "IIViewDeckController.h"
#import "EvaluationVC.h"
#import "ClassInfoVC.h"
#import "ImageManager.h"
#import <AVFoundation/AVFoundation.h>
#import "NewsViewController.h"
#import "MEBase64.h"
#import "ClassNameVC.h"
#import "SettingViewController.h"
#import "UserMenu.h"
#import "AlbumViewController.h"
//#import <ViewDeck/ViewDeck.h>
#import "UniversalVC.h"
#import "SysRequest.h"

@implementation MenuViewController
@synthesize mTableView = _mTableView;
@synthesize mClassLable = _mClassLable;
@synthesize mNameLable = _mNameLable;
@synthesize mSettingBtn = _mSettingBtn;
@synthesize mMenuArr = _mMenuArr;

/*- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

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
    // 设置tableView的数据源
    _mTableView.dataSource = self;
    
    // 设置tableView的委托
    _mTableView.delegate = self;

    self.mTableView.scrollsToTop = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _mClassLable.userInteractionEnabled = YES;
    _mNameLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *classTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(classTouchUpInside:)];
    [_mClassLable addGestureRecognizer:classTapGestureRecognizer];
    
    UITapGestureRecognizer *nameTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nameTouchUpInside:)];
    [_mNameLable addGestureRecognizer:nameTapGestureRecognizer];

    self.userHeadImage.layer.cornerRadius = 40;//self.userHeadImage.width * 0.5;
    self.userHeadImage.clipsToBounds = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onSelectHeadImage:)];
    self.userHeadImage.userInteractionEnabled = YES;
    [self.userHeadImage addGestureRecognizer:singleTap];
    //[self.userHeadImage sd_setImageWithURL:MAKE_IMG_URL(userInfo.Icon) placeholderImage:[ImageManager imageOfType:EImage_Default_Photo]];
    
    if (nil != [UserManager currentUser] ){
        [self.userHeadImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kServerAddressTest, [UserManager currentUser].Icon]] placeholderImage:[ImageManager imageOfType:EImage_Default_Photo]];

    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UserInfo *userInfo = [UserManager currentUser];
    _mClassLable.text = userInfo.CurrentUserClass;
    _mNameLable.text = userInfo.UserName;
    
    GetReadLogRequest *request = [[GetReadLogRequest alloc] init];
    request.ClassName = userInfo.CurrentUserClass;
    
    [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
        id result = request.responseBodyJSON;
        NSString *value = result[@"NewsIsRead"];
        _iNewsRead = [value intValue];
        
        value = result[@"AlbumIsRead"];
        _iAlbumRead = [value intValue];

        value = result[@"NoticeIsRead"];
        _iNoticeRead = [value intValue];

        [_mTableView reloadData];
        /*_iNewsRead   = result[@"NewsIsRead"];//AlbumIsRead   NoticeIsRead
        _iAlbumRead  = result[@"AlbumIsRead"];
        _iNoticeRead = result[@"NoticeIsRead"];*/
        
    } failure:^(NSError *err) {
    }];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)classTouchUpInside:(UITapGestureRecognizer *)recognizer{
    NSLog(@"class touch");
    ClassNameVC *className = [[ClassNameVC alloc] init];
    
    //__weak PersonalDataVC *weakSelf = self;
    //[self presentViewController:className animated:YES completion:^{
    //}];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:className];
    
    [self presentViewController:navController animated:YES completion:^{
    }];

}

-(void)nameTouchUpInside:(UITapGestureRecognizer *)recognizer{
    NSLog(@"name touch");
    ClassNameVC *className = [[ClassNameVC alloc] init];
    
    //[self presentViewController:className animated:YES completion:^{
    //}];

    
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:className];
    
    [self presentViewController:navController animated:YES completion:^{
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.mMenuArr.count > 0) {
        return [self.mMenuArr count];
    }else{
        return 0;
    }
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section > 0 ? [NSString stringWithFormat:@"%ld", (long)section-1] : nil;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        UIImage* image = [UIImage imageNamed:@"redbubble_bg.png"];
        UIImageView *icon = [[UIImageView alloc] initWithImage:image];
        icon.frame = CGRectMake(100, 15, 10, 10);
        icon.tag = 3;
        [cell.contentView addSubview:icon];
        icon.hidden = YES;
    }
    
    Menu *meunItem = _mMenuArr[indexPath.row];
    cell.textLabel.text = meunItem.MenuName;
    UIImageView *icon = (UIImageView *)[cell.contentView viewWithTag:3];

    if ([meunItem.MenuFunction isEqualToString:@"SchoolNew"]) {
        if (_iNewsRead) {
            icon.hidden = NO;
        }else{
            icon.hidden = YES;
        }
    }else if ([meunItem.MenuFunction isEqualToString:@"Album"]) {
        if (_iAlbumRead) {
            icon.hidden = NO;
        }else{
            icon.hidden = YES;
        }
    }else if ([meunItem.MenuFunction isEqualToString:@"ClassNotice"]) {
        if (_iNoticeRead) {
            icon.hidden = NO;
        }else{
            icon.hidden = YES;
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.textLabel.text = [NSString stringWithFormat:@"%ld:%ld", (long)indexPath.section-1, (long)indexPath.row];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
            Menu *menuItem = _mMenuArr[indexPath.row];
            
            if ([menuItem.MenuFunction isEqualToString:@"SchoolNew"]) {
                NewsViewController *newsVC = (NewsViewController *)[UIViewController viewControllerWithStoryboard:@"NewsViewController" identifier:@"NewsView"];
                
                UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:newsVC];
                self.viewDeckController.centerController = navController;
                
                newsVC.title = menuItem.MenuName;
                //[((UINavigationController*)controller.centerController) pushViewController:evaluate animated:YES];
            }else if ([menuItem.MenuType isEqualToString:@"HTMLA"]) {
                EvaluationVC *evaluate = (EvaluationVC *)[UIViewController viewControllerWithStoryboard:@"Evaluation" identifier:@"EvaluationVC"];
                
                evaluate.mURL = menuItem.MenuFunction;
                UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:evaluate];
                self.viewDeckController.centerController = navController;
                evaluate.title = menuItem.MenuName;

                //[((UINavigationController*)controller.centerController) pushViewController:evaluate animated:YES];
            }else if([menuItem.MenuFunction isEqualToString:@"ClassNotice"]){
                ClassInfoVC *classInfo = (ClassInfoVC *)[UIViewController viewControllerWithStoryboard:@"ClassInfo" identifier:@"ClassInfoVC"];
                
                UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:classInfo];
                self.viewDeckController.centerController = navController;
                classInfo.title = menuItem.MenuName;

            }else if ([menuItem.MenuFunction isEqualToString:@"Album"]) {
                AlbumViewController *album = (AlbumViewController *)[UIViewController viewControllerWithStoryboard:@"Album" identifier:@"AlbumVC"];
                
                UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:album];
                self.viewDeckController.centerController = navController;
                album.title = menuItem.MenuName;

                //[((UINavigationController*)controller.centerController) pushViewController:evaluate animated:YES];
            }else{
                /*UITableViewController* cc = (UITableViewController*)((UINavigationController*)controller.centerController).topViewController;
                cc.navigationItem.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
                if ([cc respondsToSelector:@selector(tableView)]) {
                    [cc.tableView deselectRowAtIndexPath:[cc.tableView indexPathForSelectedRow] animated:NO];
                }*/
                UniversalVC *universal = (UniversalVC *)[UIViewController viewControllerWithStoryboard:@"Universal" identifier:@"UniversalVC"];
                
                universal.mURL = menuItem.MenuFunction;
                universal.title = menuItem.MenuName;
                universal.iType = 2;
                
                UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:universal];
                
                self.viewDeckController.centerController = navController;
            }
        }
        [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0]; // mimic delay... not really necessary
    }];
}

- (IBAction)onSelectHeadImage:(id)sender
{
    //点击

    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"我的相册", nil];
    }else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"我的相册",nil];
    }
    
    [sheet showInView:self.view];
}

#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (buttonIndex == 0) sourceType = UIImagePickerControllerSourceTypeCamera;
        else if (buttonIndex == 1) sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        else
            return;
    }else {
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else{
            return;
        }
    }
    
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    
    [APPDELEGATE setNormalNavigationAppearance:imagePickerController];
    
    //__weak PersonalDataVC *weakSelf = self;
    [self presentViewController:imagePickerController animated:YES completion:^{
        
        if (sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            NSString *mediaType = AVMediaTypeVideo; // Or AVMediaTypeAudio
            
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            if(authStatus == AVAuthorizationStatusNotDetermined){
                
                [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                    if(!granted){
                        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的“设置-隐私-相机”中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [a show];
                    }
                }];
            }else if(authStatus == AVAuthorizationStatusDenied){
                UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的“设置-隐私-相机”中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [a show];
            }else if (authStatus == AVAuthorizationStatusRestricted){
                UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请检查相机权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [a show];
            }
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:photo];
    imageCropVC.delegate = self;
    [picker pushViewController:imageCropVC animated:YES];
}


#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    //self.avatarSelect = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [controller.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    //self.avatarSelect = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [controller.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    //self.avatar = croppedImage;
    [self uploadHeadImage:croppedImage];
}

- (void)uploadHeadImage:(UIImage *)headImg
{
    //UserInfo *userinfo = [UserManager currentUser].clone;
    //头像
    NSString *avatarString;
    if (headImg) {  //self.avatar
        NSData *data = UIImagePNGRepresentation(headImg);
        NSString *head = @"data:image/jpg;base64,";
        avatarString = [head stringByAppendingString:[MEBase64 stringByEncodingData:data]];
        //userinfo.Icon = avatarString;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    UpdateUserHeadRequest *request = [[UpdateUserHeadRequest alloc] init];
    request.HeadImg = avatarString;
    
    [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
        [SVProgressHUD dismiss];
        [self.userHeadImage setImage:headImg];
    } failure:^(NSError *err) {
        [SVProgressHUD dismiss];
        
        [[[UIAlertView alloc] initWithTitle:@"提交信息失败" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];

}

#pragma mark - open setting controller
-(IBAction)openSettingAction{    
    SettingViewController *settingVC = (SettingViewController *)[UIViewController viewControllerWithStoryboard:@"Setting" identifier:@"SettingViewController"];

    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:settingVC];

    [self presentViewController:navController animated:YES completion:^{
    }];
}

@end
