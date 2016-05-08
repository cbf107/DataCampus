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


#import "NewsViewController.h"
#import "IIViewDeckController.h"
#import "TabHomeCollCell.h"
#import "SchoolNewsRequest.h"
#import "SchoolNews.h"
#import "UniversalVC.h"
//#import <ViewDeck/ViewDeck.h>

@interface NewsViewController()
@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) NSArray *mHeadActiveArr;
@property (nonatomic, retain) NSArray *mActiveArr;

@end


@implementation NewsViewController

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
    [self.view setBackgroundColor:[UIColor colorWithHexString:AppColorNormalBkg]];

    self.mTableView.tableFooterView = [[UIView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;

    // 设置tableView的数据源
    //_mTableView.dataSource = self;
    
    // 设置tableView的委托
    //_mTableView.delegate = self;

    //self.mTableView.scrollsToTop = NO;
    [self loadHeadActiveDate];
    [self loadActiveDate];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
    
    //self.mTableView.separatorStyle = UITableViewCellSelectionStyleDefault;
}

- (void)previewBounceLeftView {
    [self.viewDeckController previewBounceView:IIViewDeckLeftSide];
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
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)loadHeadActiveDate {
    GetSchoolNewsCover *request = [[GetSchoolNewsCover alloc] init];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
        //School_Newss *schoolnews = request.parseResult;
        //_mHeadActiveArr = schoolnews.School_Newss;
        [SVProgressHUD dismiss];

        _mHeadActiveArr = request.parseResult;
        [self.mTableView reloadData];

    }failure:^(NSError *err) {
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
    
    //_mHeadActiveArr = [[NSMutableArray alloc]initWithObjects:@"bannerImage", @"bannerImage", @"bannerImage", nil ];
    //[self.mTableView reloadData];
}

-(void)loadActiveDate {
    GetSchoolNews *request = [[GetSchoolNews alloc] initWithStart:0 length:kPageCount];

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
        //School_Newss *schoolnews = request.parseResult;
        //_mActiveArr = schoolnews.School_Newss;
        [SVProgressHUD dismiss];

        _mActiveArr = request.parseResult;
        [self.mTableView reloadData];
        
    }failure:^(NSError *err) {
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
    
    /*_mActiveArr = [[NSMutableArray alloc]initWithObjects:@"bannerImage", @"bannerImage", @"bannerImage", nil ];
    [self.mTableView reloadData];*/

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0==section) {
        return 1;
    } else if (1 == section) {
        if (_mActiveArr) {
            return _mActiveArr.count;
        }else {
            return 0;
        }
    } else {
        return 0;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 239;
            
        case 1:
            return 106;
            
        default:
            return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    /*if (1 == section) {
        return 0.1;
    } else {
        return 0.1;
    }*/
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            TabHomeImgScrollCell *cell = (TabHomeImgScrollCell*)[tableView dequeueReusableCellWithIdentifier:@"TabHomeImgScrollCell"];
            if (_mHeadActiveArr) {
                [cell setInfo:_mHeadActiveArr];
            }
            return cell;
        }
            
        case 1:
        {
            TabHomeActiveCell *cell = (TabHomeActiveCell*)[tableView dequeueReusableCellWithIdentifier:@"TabHomeActiveCell"];
            [cell setInfo:_mActiveArr[indexPath.row]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            
        default:
            return 0;
    }
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section > 0 ? [NSString stringWithFormat:@"%ld", (long)section-1] : nil;
}*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        UniversalVC *universal = (UniversalVC *)[UIViewController viewControllerWithStoryboard:@"Universal" identifier:@"UniversalVC"];
        
        School_News *news = _mActiveArr[indexPath.row];
        universal.mURL = news.Url;
        universal.title = news.Title;
        
        [self.navigationController pushViewController:universal animated:YES];
    }

}

@end
