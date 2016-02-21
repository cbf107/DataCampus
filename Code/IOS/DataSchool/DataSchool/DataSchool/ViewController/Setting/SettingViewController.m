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

#import "SettingViewController.h"
#import "ModifyPasswordVC.h"
#import "SettingWebVC.h"
#import "UniversalVC.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@end

@implementation SettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

-(void)commonInit {
    self.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    self.logoutBtn.layer.cornerRadius = 4;
    [self.logoutBtn setBackgroundColor:[UIColor colorWithHexString:kAppColorNavBkg]];

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftButton;

}

-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)onLogout:(UIButton *)sender{
    [[[UIAlertView alloc] initWithTitle:@"提示"
                                message:@"确定要退出吗？"
                               delegate:self
                      cancelButtonTitle:@"取消"
                      otherButtonTitles:@"确定", nil] show];

}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
    if (buttonIndex == 1) {
        [UserManager logOut:^{
            [self logOutSuccess];
        }];
    }
}

-(void)logOutSuccess{
    UIViewController *launchVC = [UIViewController viewControllerWithStoryboard:@"Login" identifier:@"LoginVC"];
    AppDelegate *d = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [d.window setRootViewController:launchVC];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 15;
    }
    return 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if ([indexPath row] == 0) {
            ModifyPasswordVC *modifyVC = (ModifyPasswordVC *)[UIViewController viewControllerWithStoryboard:@"Setting" identifier:@"ModifyPasswordVC"];
            [self.navigationController pushViewController:modifyVC animated:YES];
        }else if([indexPath row] == 1) {
            SettingWebVC *settingWebVC = (SettingWebVC *)[UIViewController viewControllerWithStoryboard:@"Setting" identifier:@"SettingWebVC"];
            settingWebVC.sTitle = @"我的二维码";
            
            //UserInfo *userInfo = [UserManager currentUser];
            
            settingWebVC.sURL = [NSString stringWithFormat:@"%@%@", kServerAddressTest, [UserManager currentUser].UserQRURL];
            [self.navigationController pushViewController:settingWebVC animated:YES];
        }else if([indexPath row] == 2) {
            UniversalVC *universal = (UniversalVC *)[UIViewController viewControllerWithStoryboard:@"Universal" identifier:@"UniversalVC"];
            
            UserInfo *userInfo = [UserManager currentUser];
            for (int i = 0; i < userInfo.UserClasses.count; i++) {
                UserClass *class = userInfo.UserClasses[i];
                if ([userInfo.CurrentUserClass isEqualToString:class.ClassName]) {
                    universal.mURL = [NSString stringWithFormat:@"%@%@", kServerAddressTest, class.URL];

                    //universal.mURL = class.URL;
                    universal.mPhone = class.PhoneNum;
                    universal.iType = 1;
                    break;
                }
            }
            
            universal.title = @"班主任";
            
            [self.navigationController pushViewController:universal animated:YES];
        }
        
    }
}

@end
/*
#define CELLHEIGHT  44
@implementation SettingViewController
@synthesize tableView = _tableView;


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
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTableView];
    //[self addNavigationBar];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

-(void)addTableView{
    //初始化表格
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    // 设置协议，意思就是UITableView类的方法交给了tabView这个对象，让完去完成表格的一些设置操作
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    //self.tableView.tableFooterView = [[UIView alloc]init];
    _tableView.sectionFooterHeight = 20;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //把tabView添加到视图之上
    [self.view addSubview:self.tableView];
}

-(void)addNavigationBar{
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    //创建一个左边按钮
    //UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"左边" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backAction)];
    
    
    //设置导航栏内容
    [navigationItem setTitle:@"设置"];
    //把导航栏集合添加入导航栏中，设置动画关闭
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    //把左右两个按钮添加入导航栏集合中
    [navigationItem setLeftBarButtonItem:leftButton];
    
    //把导航栏添加到视图中
    [self.view addSubview:navigationBar];
}

-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)logoutButton{
    
}
#pragma mark - Table view data source
- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section{
    return 20 ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([indexPath row] == 0) {
            cell.textLabel.text = @"修改密码";
        }else if ([indexPath row] == 1) {
            cell.textLabel.text = @"我的二维码";
        }else if ([indexPath row] == 2) {
            cell.textLabel.text = @"班主任：王老师";
        }else if ([indexPath row] == 3) {
            cell.textLabel.text = @"关于";
        }

    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            logoutBtn.layer.cornerRadius = 4;
            logoutBtn.frame = CGRectMake(12,
                                         0,
                                         _tableView.frame.size.width - 24,
                                         CELLHEIGHT);
            
            [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];//self.cancelButton
            [logoutBtn setBackgroundColor:[UIColor colorWithHexString:kAppColorNavBkg]];
            [logoutBtn setTitleColor:[UIColor colorWithHexString
                                      :KAppFontColorTitle] forState
                                    :UIControlStateNormal];
            logoutBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            logoutBtn.titleLabel.textColor = [UIColor whiteColor];
            [logoutBtn addTarget:self action
                                :@selector(logoutButton) forControlEvents
                                :UIControlEventTouchUpInside];
            [cell addSubview:logoutBtn];

            setLastCellSeperatorToLeft:cell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

    }
    
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if ([indexPath row] == 0) {
            ModifyPasswordVC *modifyVC = (ModifyPasswordVC *)[UIViewController viewControllerWithStoryboard:@"Setting" identifier:@"ModifyPasswordVC"];
            [self.navigationController pushViewController:modifyVC animated:YES];
        }else if([indexPath row] == 1) {
            SettingWebVC *settingWebVC = (SettingWebVC *)[UIViewController viewControllerWithStoryboard:@"Setting" identifier:@"SettingWebVC"];
            settingWebVC.sTitle = @"我的二维码";
            [self.navigationController pushViewController:settingWebVC animated:YES];
        }

    }
}

@end*/
