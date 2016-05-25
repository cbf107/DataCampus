//
//  FillPersonInfoVC
//  ZhiKu
//
//  Created by mac on 15/5/22.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "TeacherLeaveVC.h"
#import <QuartzCore/QuartzCore.h>
#import "LeaveTimeCell.h"
#import "LeaveTypeCell.h"
#import "LeaveMsgCell.h"
#import "LeaveFlowCell.h"
#import "LeaveRequest.h"
#import "LeaveInfo.h"

@interface TeacherLeaveVC ()
@property (nonatomic, retain) ZHPickView *mDataPickview;
@property (nonatomic, retain) PopDatePickerView *popDatePickerView;
@property (nonatomic, assign)int currentIndex;
@property (nonatomic, copy)NSString *startTime;
@property (nonatomic, copy)NSString *endTime;
@property (nonatomic, copy)NSString *leaveType;

@property (nonatomic, copy)NSMutableArray *workArray;
@property (nonatomic, copy)NSMutableArray *nameArray;

@property (nonatomic, retain) NSIndexPath *workIndex;
@end

@implementation TeacherLeaveVC
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.sectionIndexColor=[UIColor colorWithHexString:@"168afc"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction)];

    // 点击listview 关闭键盘
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitEditMode)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tableViewGesture];

    _startTime = @"请选择请假开始时间";
    _endTime = @"请选择请假结束时间";
    _leaveType = @"请假类型";
    
    [self initWorkInfo];
}

-(void)initWorkInfo{
    LeaveWorkRequest *request = [[LeaveWorkRequest alloc]init];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
        [SVProgressHUD dismiss];
        
        _workArray = [[NSMutableArray alloc] init];
        _nameArray = [[NSMutableArray alloc] init];
        
        NSArray *leaveArray = request.parseResult;
        for (int i = 0; i < leaveArray.count; i++) {
            LeaveWork *type = leaveArray[i];
            [_workArray addObject:type.ItemName];
            [_nameArray addObject:@"请选择"];
        }
        
        [self.tableView reloadData];
    }failure:^(NSError *err) {
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_mDataPickview) {
        [_mDataPickview remove];
        _mDataPickview = nil;
    }

}


- (void)doneAction {
    NSLog(@"doneAction");
}

//ZHPickView
-(IBAction)onSelectData:(id)sender{
    if (_mDataPickview) {
        [_mDataPickview remove];
        _mDataPickview = nil;
    }
    
    LeaveTypeRequest *request = [[LeaveTypeRequest alloc]init];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
        [SVProgressHUD dismiss];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];

        NSArray *leaveArray = request.parseResult;
        for (int i = 0; i < leaveArray.count; i++) {
            LeaveType *type = leaveArray[i];
            [array addObject:type.ItemName];
        }

        _mDataPickview=[[ZHPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
        _mDataPickview.tag = 100;
        _mDataPickview.delegate=self;
        [_mDataPickview show];

    }failure:^(NSError *err) {
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];


}



-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    NSLog(@"resultString = %@", resultString);
    if(pickView.tag == 100){
        LeaveTypeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];

        _leaveType = resultString;
        [cell.mBtnType setTitle:_leaveType forState:UIControlStateNormal];
    }
}

#pragma mark
#pragma mark --- UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 5) {
        return _workArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
            //开始时间
        case 0:
            return 50;
            
            //结束时间
        case 1:
            return 50;
            
            //请假类型
        case 2:
            return 60;
            
            //请假内容描述
        case 3:
            return 120;
            
            //请假上传的图片
        case 4:
            return 120;

            //请假工作安排
        case 5:
            return 60;

        default:{
            return 0;
        }
            
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LeaveTimeCell" forIndexPath:indexPath];
            cell.textLabel.text = _startTime;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LeaveTimeCell" forIndexPath:indexPath];
            cell.textLabel.text = _endTime;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            //[(ConfirmOrderPickupCell *)cell setPickup:_sendStr];
            
        }
            break;
            
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LeaveTypeCell" forIndexPath:indexPath];
            [((LeaveTypeCell *)cell).mBtnType setTitle:_leaveType forState:UIControlStateNormal];

        }
            break;
            
        case 3: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LeaveMsgCell" forIndexPath:indexPath];
            
            //[(ConfirmOrderPriceCell *)cell setPrice:[NSString stringWithFormat:@"共%@件商品 合计:￥%@", _totalNum, _totalMoney]];
            //[(ConfirmOrderPriceCell *)cell setExpress:[NSString stringWithFormat:@"运费:￥%@", _express_price]];
        }
            break;
        
        case 4: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LeaveImgCell" forIndexPath:indexPath];
            
        }
            break;
    
        case 5: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LeaveFlowCell" forIndexPath:indexPath];
            ((LeaveFlowCell *)cell).mWorkLabel.text = _workArray[indexPath.row];
            ((LeaveFlowCell *)cell).mNameLabel.text = _nameArray[indexPath.row];

            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
            break;

        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 ||
        indexPath.section == 1) {
        _currentIndex = (int)indexPath.section;
        
        if (_popDatePickerView == nil) {
            
            if (IS_IOS7) {
                //_popDatePickerView = [[PopDatePickerView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] applicationFrame].size.height, self.view.frame.size.width, 206)];
                _popDatePickerView = [[PopDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-206, self.view.frame.size.width, 206)];
            }else {
                //_popDatePickerView = [[PopDatePickerView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] applicationFrame].size.height, self.view.frame.size.width, 260)];
                _popDatePickerView = [[PopDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-260, self.view.frame.size.width, 206)];

            }
            
            _popDatePickerView.backgroundColor = [UIColor clearColor];
            _popDatePickerView.delegate = self;
            
            // 设置时间格式 如果不设置则显示默认
            [_popDatePickerView setDatePickerMode:UIDatePickerModeDateAndTime];
            
            // 设置时间显示的格式 如果不设置则显示默认
            [_popDatePickerView setDateFormatter:[NSString stringWithFormat:@"%@", @"yyyy-MM-dd HH:mm"]];
            
            // 设置时间是否中文显示 如果不设置则显示默认
            [_popDatePickerView setDateLocal:[[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"]];
            
            [self.parentViewController.view addSubview:_popDatePickerView];

        }else{
            [_popDatePickerView setHidden:NO];
        }
        
        
    }else if (indexPath.section == 5) {
        _workIndex = indexPath;
        
        SearchVC *search = [[SearchVC alloc] init];
        search.mTitle = _workArray[indexPath.row];
        search.delegate = self;

        [self.navigationController pushViewController:search animated:YES];

    }
}

- (void) doneBarButtonItemClicked:(NSString *)strDate {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_currentIndex]];

    if (_currentIndex == 0) {
        _startTime = [NSString stringWithFormat:@"请假开始时间:%@", strDate];
        cell.textLabel.text = _startTime;

    }else if(_currentIndex == 1) {
        _endTime = [NSString stringWithFormat:@"请假结束时间:%@", strDate];
        cell.textLabel.text = _endTime;

    }
    
    [_popDatePickerView setHidden:YES];
}

- (void) cancelBarButtonItemClicked{
    //[self stopAnimation];
    [_popDatePickerView setHidden:YES];
}

//工作安排里面选择老师
- (void) selectData:(NSString *)strData{
    NSLog(@"strData = %@", strData);
    //UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_workIndex];
    //((LeaveFlowCell *)cell).mNameLabel.text = strData;
    
    [_nameArray replaceObjectAtIndex:_workIndex.row withObject:strData];
    [self.tableView reloadData];
}

#pragma mark - UITextFieldDelegate
// 获取第一响应者时调用
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_mDataPickview) {
        [_mDataPickview remove];
        _mDataPickview = nil;
    }

    [_popDatePickerView setHidden:YES];

    return YES;
}

// 失去第一响应者时调用
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [_popDatePickerView setHidden:YES];
    return YES;
}

// 按enter时调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [_popDatePickerView setHidden:YES];

    return YES;
}


- (void)exitEditMode{
    
    if (_mDataPickview) {
        [_mDataPickview remove];
        _mDataPickview = nil;
    }
    
    [_popDatePickerView setHidden:YES];

}
@end
