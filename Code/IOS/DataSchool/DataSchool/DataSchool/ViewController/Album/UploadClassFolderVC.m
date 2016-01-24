//
//  RelationshipVC.m
//  ZhiKu
//
//  Created by mac on 15/5/20.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "UploadClassFolderVC.h"
#import "AlbumRequest.h"

@implementation UploadClassFolderVC

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化表格
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    // 设置协议，意思就是UITableView类的方法交给了tabView这个对象，让完去完成表格的一些设置操作
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    //self.tableView.tableFooterView = [[UIView alloc]init];
    //把tabView添加到视图之上
    [self.view addSubview:self.tableView];

    //存放显示在单元格上的数据
    //UserInfo *userInfo = [UserManager currentUser];
    //self.listData = userInfo.UserClasses;
    [self initData];
    
    _data  = [[NSMutableArray alloc] init];
    [_data addObject:_folderID];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(uploadAction)];

}

-(void)initData{
    GetUploadFolderList *request = [[GetUploadFolderList alloc] init];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
        [SVProgressHUD dismiss];

        self.listData = request.parseResult;
        [self.tableView reloadData];
    } failure:^(NSError *err) {
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
    
}

- (void)uploadAction {
    if (_data.count == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择至少一个相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }else{
        UploadImage *request = [[UploadImage alloc] init];
        request.Img = _mImg;
        request.Title = @"测试上传";
        request.Folders = [NSArray arrayWithArray:_data];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
            [SVProgressHUD dismiss];

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = 1;
            [alert show];
        } failure:^(NSError *err) {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:@"失败" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FolderInfo *info = _listData[section];
    return info.AlbumFolder.count;
}

#pragma mark -允许数据源告知必须加载到Table View中的表的Section数。
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_listData count];
}

#pragma mark -Section的Header的值
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    FolderInfo *info = _listData[section];
    return info.ClassName;
}

#pragma mark - Section header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    lab.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    lab.text = ((UserClass *)_listData[section]).ClassName;
    lab.textColor = [UIColor colorWithHexString:@"333e4c"];
    
    [self resetContent:lab];
    return lab;
}

//自适应计算间距
- ( void )resetContent:(UILabel *)contentLabel{
    NSMutableAttributedString *attributedString = [[ NSMutableAttributedString alloc ] initWithString : contentLabel.text ];
    
    NSMutableParagraphStyle *paragraphStyle = [[ NSMutableParagraphStyle alloc ] init ];
    
    paragraphStyle.alignment = NSTextAlignmentLeft ;
    
    [paragraphStyle setFirstLineHeadIndent:16]; //首行缩进16个像素
    
    [attributedString addAttribute : NSParagraphStyleAttributeName value:paragraphStyle range : NSMakeRange (0 , [contentLabel.text length])];
    
    contentLabel.attributedText = attributedString;
    
    [contentLabel sizeToFit];
}

#pragma mark - row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.tag = 0;

    FolderInfo *info = _listData[indexPath.section];
    AlbumFolder *album = info.AlbumFolder[indexPath.row];
    
    if ([album.AlbumRefId isEqualToString:_folderID]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.tag = 1;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", album.AlbumName];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FolderInfo *info = _listData[indexPath.section];
    AlbumFolder *album = info.AlbumFolder[indexPath.row];
    NSString *folderID = album.AlbumRefId;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.tag == 1) {
        cell.tag = 0;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [_data removeObject:folderID];
    }else{
        cell.tag = 1;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [_data addObject:folderID];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中的颜色
}

@end
