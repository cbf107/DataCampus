//
//  RelationshipVC.m
//  ZhiKu
//
//  Created by mac on 15/5/20.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "PublishClassNameVC.h"

@implementation PublishClassNameVC

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
    UserInfo *userInfo = [UserManager currentUser];
    self.listData = userInfo.UserClasses;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleBordered target:self action:@selector(chooseAction)];

}

- (void)chooseAction {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (int i = 0; i < _listData.count; i++) {
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];

        if (cell.tag == 1) {
            UserClass *userClass = [self.listData objectAtIndex:i];
            [data addObject:userClass.ClassName];
        }
    }
    
    if (data.count == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择至少一个班级" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }else{
        [self.passDelegate passValue:[NSArray arrayWithArray:data]];

        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listData count];
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
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.tag = 0;

    UserClass *userClass = _listData[indexPath.row];
    
    for(int i = 0; i < _checkedName.count; i++){
        if ([userClass.ClassName isEqualToString:_checkedName[i]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.tag = 1;
            break;
        }
    }
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", userClass.ClassName];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.tag == 1) {
        cell.tag = 0;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.tag = 1;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中的颜色
    /*UserInfo *userInfo = [UserManager currentUser];
    UserClass *userClass = userInfo.UserClasses[indexPath.row];
    userInfo.CurrentUserClass = userClass.ClassName;

    if (userInfo != nil) {
        [UserManager loginSuccessWithUserInfo:userInfo];
    }

    [self dismissViewControllerAnimated:YES completion:NULL];*/
}

@end
