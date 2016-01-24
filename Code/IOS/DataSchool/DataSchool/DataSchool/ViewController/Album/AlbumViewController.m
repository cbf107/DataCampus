
//
//  RootViewController.m
//  NewProject
//
//  Created by 学鸿 张 on 13-11-29.
//  Copyright (c) 2013年 Steven. All rights reserved.
//

#import "AlbumViewController.h"
#import "IIViewDeckController.h"
#import "AlbumTableViewCell.h"
#import "ThumbnailVC.h"

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
    
    // Do any additional setup after loading the view.
    self.mTableView.tableFooterView = [[UIView alloc]init];
    self.mTableView.refreshStatusViewBlock = ^(RefreshTableViewStatus status){
        if (status == RefreshTableViewStatusNoResult) {
            self.mTableView.tableHeaderView = [[RefreshStatusView alloc] initWithImageName:@"message_img" text:@"还没有相册"];
        }else {
            self.mTableView.tableHeaderView = [RefreshStatusView statusViewWithStatus:status];
        }
    };
    
    [self setupHeader];//下拉刷新

}

- (void)setupHeader
{
    if (!self.pullRequest) {
        self.pullRequest = [[GetAlbumFolderRequest alloc] initWithStart:0 length:kPageCount];
        self.mTableView.request = self.pullRequest;
        UserInfo *userInfo = [UserManager currentUser];
        self.pullRequest.CurrentClassName = userInfo.CurrentUserClass;
        [self.mTableView addHeader];
        
    }
    
    [self.mTableView headerBeginRefreshing];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 6;
    if (nil != [((RefreshTableView*) tableView) dataArray]) {
        return [[((RefreshTableView*) tableView) dataArray] count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableCellIdentifier = @"AlbumTableViewCell";
    
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                               TableCellIdentifier];
    if (cell != nil) {
        AlbumFolder *info = [[((RefreshTableView*) tableView) dataArray] objectAtIndex:indexPath.row];
        
        [cell setInfo:info];
        
        cell.mIndexPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return (UITableViewCell *)cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ThumbnailVC *thumbVC = (ThumbnailVC *)[UIViewController viewControllerWithStoryboard:@"Album" identifier:@"ThumbnailVC"];
    
    AlbumFolder *info = [[((RefreshTableView*) tableView) dataArray] objectAtIndex:indexPath.row];
    thumbVC.sAlbumRefId = info.AlbumRefId;
    [self.navigationController pushViewController:thumbVC animated:YES];
}


@end
