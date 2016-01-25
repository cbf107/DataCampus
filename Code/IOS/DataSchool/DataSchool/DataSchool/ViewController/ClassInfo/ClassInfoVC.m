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

#import "ClassInfoVC.h"
#import "InfoPublishVC.h"
#import "IIViewDeckController.h"
#import "InfoTableViewCell.h"
#import "DetailInfoVC.h"
#import "ClassNotice.h"
//#import <ViewDeck/ViewDeck.h>

@implementation ClassInfoVC

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

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(addAction)];
    
    self.mTableView.tableFooterView = [[UIView alloc]init];
    self.mTableView.refreshStatusViewBlock = ^(RefreshTableViewStatus status){
        if (status == RefreshTableViewStatusNoResult) {
            self.mTableView.tableHeaderView = [[RefreshStatusView alloc] initWithImageName:@"message_img" text:@"还没有消息哦"];
        }else {
            self.mTableView.tableHeaderView = [RefreshStatusView statusViewWithStatus:status];
        }
    };
    
    [self setupHeader];//下拉刷新

}

- (void)setupHeader
{
    if (!self.pullRequest) {
        self.pullRequest = [[GetClassNoticeRequest alloc] initWithStart:0 length:kPageCount];
        self.mTableView.request = self.pullRequest;
        
        UserInfo *userInfo = [UserManager currentUser];
        self.pullRequest.className = userInfo.CurrentUserClass;
        self.pullRequest.Type = @"";
        [self.mTableView addHeader];
        
    }
    
    [self.mTableView headerBeginRefreshing];
}

- (void)addAction {
    InfoPublishVC *publishVC = (InfoPublishVC *)[UIViewController viewControllerWithStoryboard:@"ClassInfo" identifier:@"InfoPublishVC"];

    [self.navigationController pushViewController:publishVC animated:YES];
    NSLog(@"addAction");
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
    static NSString *TableCellIdentifier = @"InfoTableViewCell";
    
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                  TableCellIdentifier];
    if (cell != nil) {
        ClassNotice *info = [[((RefreshTableView*) tableView) dataArray] objectAtIndex:indexPath.row];
        /*ClassInfo *info = [[ClassInfo alloc] init];
        info.sTitle = @"恒大进入四强";
        info.sSubTitle = @"恒大进入四强,对战巴萨";
        info.sURL = @"http://www.baidu.com";
        info.iType = 0;*/

        [cell setInfo:info];
        
        cell.mIndexPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return (UITableViewCell *)cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*if (!indexPath.section) {
        self.viewDeckController.leftSize = MAX(indexPath.row*44,10);
    }
    else {
        self.viewDeckController.rightSize = MAX(indexPath.row*44,10);
    }*/
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassNotice *info = [[((RefreshTableView*) tableView) dataArray] objectAtIndex:indexPath.row];

    DetailInfoVC *detailVC = (DetailInfoVC *)[UIViewController viewControllerWithStoryboard:@"ClassInfo" identifier:@"DetailInfoVC"];
    detailVC.sURL = info.Url;
    detailVC.mStatusUrl = info.StatusUrl;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
/*    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DeleteMsgRequest *requester = [[DeleteMsgRequest alloc] init];
        MessageInfo *msgInfo = [[((RefreshTableView*) tableView) dataArray] objectAtIndex:indexPath.row];
        requester.sMsg = msgInfo.iMsg;
        requester.iClass = 1;
        
        [requester startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
            [[((RefreshTableView*) tableView) dataArray] removeObjectAtIndex:indexPath.row];
            
            [_mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        } failure:^(NSError *err) {
            [[[UIAlertView alloc] initWithTitle:@"错误" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }*/
}


@end
