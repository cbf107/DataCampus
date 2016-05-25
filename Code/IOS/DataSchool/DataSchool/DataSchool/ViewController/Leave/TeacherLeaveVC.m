//
//  FillPersonInfoVC
//  ZhiKu
//
//  Created by mac on 15/5/22.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "FillPersonInfoVC.h"
#import "InsetsTextField.h"
#import <QuartzCore/QuartzCore.h>
#import "RegRequest.h"
#import "SchoolInfos.h"
#import "AddressListVC.h"
#import "OrderInfo.h"
#import "OrderRequest.h"

@interface FillPersonInfoVC ()
@property (nonatomic, retain) IBOutlet InsetsTextField *mEditName;
@property (nonatomic, retain) IBOutlet InsetsTextField *mEditNumber;
@property (nonatomic, retain) IBOutlet InsetsTextField *mEditMail;

@property (nonatomic, retain) IBOutlet UIButton *mBtnSex;
@property (nonatomic, retain) IBOutlet UIButton *mBtnYear;
@property (nonatomic, retain) IBOutlet UIButton *mBtnMonth;
@property (nonatomic, retain) IBOutlet UIButton *mBtnDay;
@property (nonatomic, retain) IBOutlet UIButton *mBtnClass;
@property (nonatomic, retain) IBOutlet UIButton *mBtnCollege;
@property (nonatomic, retain) IBOutlet UIButton *mBtnSchool;

@property (nonatomic, retain) IBOutlet UIButton *mBtnAddress;

@property (nonatomic, retain) ZHPickView *mDataPickview;

@property (nonatomic, copy)NSString *keyid;
@property (nonatomic, copy)NSString *collegeid;
@property (nonatomic, copy)NSString *classid;
@property (nonatomic, copy)NSString *year;
@property (nonatomic, copy)NSString *month;
@property (nonatomic, copy)NSString *day;

@property (nonatomic, retain)NSArray *data;
@property (nonatomic, retain)AddressInfo *addressInfo;
@property (nonatomic, copy)NSString *strAddress;
@end

@implementation FillPersonInfoVC
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.sectionIndexColor=[UIColor colorWithHexString:@"168afc"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction)];

    self.title = @"完善资料";

    [self initEditText:_mEditName];
    [self initEditText:_mEditNumber];
    [self initEditText:_mEditMail];

    [self initImgBtn:_mBtnSex];
    [self initImgBtn:_mBtnYear];
    [self initImgBtn:_mBtnMonth];
    [self initImgBtn:_mBtnDay];
    [self initImgBtn:_mBtnClass];
    [self initImgBtn:_mBtnSchool];
    [self initImgBtn:_mBtnCollege];
    [self initImgBtn:_mBtnAddress];
    
    // 点击listview 关闭键盘
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitEditMode)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tableViewGesture];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self initReceive];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_mDataPickview) {
        [_mDataPickview remove];
        _mDataPickview = nil;
    }
}

//获取默认收件人信息
-(void)initReceive{
    //获取收货地址
    UserInfo *info = [UserManager currentUser];
    GetAddressListRequest *addRequest = [[GetAddressListRequest alloc]init];
    addRequest.uId = [info.uid intValue];
    addRequest.status = 1;
    
    [addRequest startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
        NSArray *array = request.parseResult;
        if (array.count > 0) {
            _addressInfo = array[0];
            _strAddress = [NSString stringWithFormat:@"%@%@", _addressInfo.area_name, _addressInfo.address];
            
            UITableViewCell *recCell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
            id controller = [recCell viewWithTag:200];
            [(UIButton *)controller setTitle:_strAddress forState:UIControlStateNormal];
            
            [(UIButton *)controller setTitleColor:[UIColor colorWithHexString:@"b3b3b3"] forState:UIControlStateNormal];

        }else{
            _strAddress = @"请选择地址";
        }
    }failure:^(NSError *err) {
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
    
}

- (void)doneAction {
    NSLog(@"doneAction");
    if (_mEditName.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入姓名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    
    if (_mEditNumber.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入学号/工号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }

    if (_strAddress.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入联系方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }

    if(![self isValidateEmail:_mEditMail.text]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"电子邮箱格式不正确，请核对后输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    
    if (_keyid == 0 || _classid == 0 || _collegeid == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择班级信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];

        return;
    }

    UserInfo *info = [UserManager currentUser];
    FillInfoRequest *request = [[FillInfoRequest alloc]init];
    request.uId = [info.uid intValue];
    request.nickname = _mEditName.text;
    request.email = _mEditMail.text;
    request.schoolId = [_keyid intValue];
    request.collegeId = [_collegeid intValue];
    request.curriculaId = [_classid intValue];
    request.birthday = [NSString stringWithFormat:@"%@-%@-%@", _year, _month, _day];
    request.cardNumber = _mEditNumber.text;
    //应该传addressId   _addressInfo.key_id
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
        [SVProgressHUD dismiss];
        
        info.nickname = _mEditName.text;
        info.email = _mEditMail.text;
        info.schoolid = _keyid;
        [UserManager loginSuccessWithUserInfo:info];

        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"个人信息提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        
    }failure:^(NSError *err) {
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIViewController *newsVC = [UIViewController viewControllerWithStoryboard:@"Main" identifier:@"HomeTabRootVC"];
    
    [self presentViewController:newsVC animated:YES completion:nil];
}

//利用正则表达式验证
-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(void)initEditText:(InsetsTextField *)textField{
    textField.layer.borderWidth = 1.0f;
    textField.layer.borderColor=[[UIColor colorWithHexString:@"b3b3b3"] CGColor];
    [textField setDelegate:self];
}

-(void)initImgBtn:(UIButton *)imgBtn{
    CGFloat top = 5; // 顶端盖高度
    CGFloat bottom = 5 ; // 底端盖高度
    CGFloat left = 5; // 左端盖宽度
    CGFloat right = 35; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    UIImage *imageBkg = [UIImage imageNamed:@"dropdown_btn"];
    imageBkg = [imageBkg resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [imgBtn setBackgroundImage:imageBkg forState:UIControlStateNormal];
    
    imgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    imgBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [imgBtn setTitleColor:[UIColor colorWithHexString:@"b3b3b3"] forState:UIControlStateNormal];

}

#pragma mark - Section header view
//别忘了设置高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    //lab.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor colorWithHexString:@"2f9220"];
    lab.font = [UIFont boldSystemFontOfSize:14];

    if (section == 0) {
        lab.text = @"姓名*";
        [self resetContent:lab start:2 length:1];

    }else if (section == 1){
        lab.text = @"出生日期";
        [self resetContent:lab start:0 length:[lab.text length]];
    }else if (section == 2){
        lab.text = @"工号/学号*";
        [self resetContent:lab start:5 length:1];

    }else if (section == 3){
        lab.text = @"班级信息*";
        [self resetContent:lab start:4 length:1];

    }else if (section == 4){
        lab.text = @"联系方式*";
        [self resetContent:lab start:4 length:1];

    }else if (section == 5){
        lab.text = @"电子邮件";
        [self resetContent:lab start:0 length:[lab.text length]];

    }

    return lab;
}

//自适应计算间距
- ( void )resetContent:(UILabel *)contentLabel start:(int)iStart length:(NSUInteger)iLength{
    NSMutableAttributedString *attributedString = [[ NSMutableAttributedString alloc ] initWithString : contentLabel.text ];
    
    NSMutableParagraphStyle *paragraphStyle = [[ NSMutableParagraphStyle alloc ] init ];
    
    paragraphStyle.alignment = NSTextAlignmentLeft ;
    
    [paragraphStyle setFirstLineHeadIndent:36]; //首行缩进16个像素
    
    if (iStart > 0) {
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:@"ED6122"]
                                 range:NSMakeRange(iStart, iLength)];

    }

    [attributedString addAttribute : NSParagraphStyleAttributeName value:paragraphStyle range : NSMakeRange (0 , [contentLabel.text length])];
    
    contentLabel.attributedText = attributedString;
    
    [contentLabel sizeToFit];
}

#pragma mark - UITextFieldDelegate
// 获取第一响应者时调用
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_mDataPickview) {
        [_mDataPickview remove];
        _mDataPickview = nil;
    }

    //textField.layer.cornerRadius = 8.0f;
    // textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[UIColor colorWithHexString:@"2BB017"] CGColor];
    return YES;
}

// 失去第一响应者时调用
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.layer.borderColor=[[UIColor colorWithHexString:@"b3b3b3"] CGColor];
    return YES;
}

// 按enter时调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


//actionsheet
- (IBAction)onSelectSex:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    
    [sheet showInView:self.view];
}

#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [_mBtnSex setTitle: @"男" forState: UIControlStateNormal];
    }else if (buttonIndex == 1){
        [_mBtnSex setTitle: @"女" forState: UIControlStateNormal];
    }
}


//ZHPickView
-(IBAction)onSelectData:(id)sender{
    if (_mDataPickview) {
        [_mDataPickview remove];
        _mDataPickview = nil;
    }

    if(((UIButton*)sender).tag == 100){//年
        NSLog(@"100");
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int i = 1900; i < 2016; i++) {
            [array addObject:[NSString stringWithFormat:@"%d", i+1]];
        }
        _mDataPickview=[[ZHPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
        _mDataPickview.tag = 100;
        _mDataPickview.delegate=self;
        [_mDataPickview show];

    }else if(((UIButton*)sender).tag == 101){//月
        NSLog(@"101");
        if (_year == 0) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择年" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return;
        }
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 12; i++) {
            [array addObject:[NSString stringWithFormat:@"%d", i+1]];
        }
        _mDataPickview=[[ZHPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
        _mDataPickview.tag = 101;
        _mDataPickview.delegate=self;
        [_mDataPickview show];

    }else if(((UIButton*)sender).tag == 102){//日
        NSLog(@"102");
        if (_month == 0) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择月" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return;
        }

        int currentDays;
        switch ([_month intValue]) {
            case 1: currentDays = 31; break;
            case 2:
                if ([self bissextile:[_year intValue]]) {
                    currentDays = 29;
                }else{
                    currentDays = 28;
                }
                break;
            case 3: currentDays = 31; break;
            case 4: currentDays = 30; break;
            case 5: currentDays = 31; break;
            case 6: currentDays = 30; break;
            case 7: currentDays = 31; break;
            case 8: currentDays = 31; break;
            case 9: currentDays = 30; break;
            case 10: currentDays = 31; break;
            case 11: currentDays = 30; break;
            case 12: currentDays = 31; break;
    
            default:
                break;
        }

        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < currentDays; i++) {
            [array addObject:[NSString stringWithFormat:@"%d", i+1]];
        }
        _mDataPickview=[[ZHPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
        _mDataPickview.tag = 102;
        _mDataPickview.delegate=self;
        [_mDataPickview show];

    }else if(((UIButton*)sender).tag == 103){//班级
        NSLog(@"103");
        if ([_keyid intValue] == 0) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择院校" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return;
        }

        UserCollegeRequest *request = [[UserCollegeRequest alloc]init];
        request.cId = [_collegeid intValue];
        request.level = 2;
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
            [SVProgressHUD dismiss];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            _data = request.parseResult;
            for (int i = 0; i < _data.count; i++) {
                [array addObject:((SchoolInfos *)_data[i]).name];
            }
            _mDataPickview=[[ZHPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
            _mDataPickview.tag = 103;
            _mDataPickview.delegate=self;
            [_mDataPickview show];
        } failure:^(NSError *err) {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];

    }else if(((UIButton*)sender).tag == 104){//专业
        NSLog(@"104");
    }else if(((UIButton*)sender).tag == 105){//院校
        NSLog(@"105");
        if ([_keyid intValue] == 0) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择学校" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return;
        }

        UserCollegeRequest *request = [[UserCollegeRequest alloc]init];
        request.cId = [_keyid intValue];
        request.level = 1;
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
            [SVProgressHUD dismiss];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            _data = request.parseResult;
            for (int i = 0; i < _data.count; i++) {
                [array addObject:((SchoolInfos *)_data[i]).name];
            }
            _mDataPickview=[[ZHPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
            _mDataPickview.tag = 105;
            _mDataPickview.delegate=self;
            [_mDataPickview show];
        } failure:^(NSError *err) {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];

    }else if(((UIButton*)sender).tag == 106){//学校
        NSLog(@"106");
        UserInfo *user = [UserManager currentUser];
        
        UserSchoolRequest *request = [[UserSchoolRequest alloc]init];
        request.uid = [user.uid intValue];
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
            [SVProgressHUD dismiss];

            NSMutableArray *array = [[NSMutableArray alloc] init];

            _data = request.parseResult;
            for (int i = 0; i < _data.count; i++) {
                [array addObject:((SchoolInfos *)_data[i]).name];
            }
            _mDataPickview=[[ZHPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
            _mDataPickview.tag = 106;
            _mDataPickview.delegate=self;
            [_mDataPickview show];
        } failure:^(NSError *err) {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];

    }else{//性别
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:@"男"];
        [array addObject:@"女"];
        _mDataPickview=[[ZHPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
        _mDataPickview.delegate=self;
        [_mDataPickview show];

    }
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    NSLog(@"resultString = %@", resultString);
    if (pickView.tag == 106) {//学校
        [_mBtnSchool setTitle:resultString forState:UIControlStateNormal];
        
        for (int i = 0; i < _data.count; i++) {
            SchoolInfos *info = _data[i];
            if ([info.name isEqualToString:resultString]) {
                _keyid = info.key_id;
                return;
            }
            
        }
    }else if(pickView.tag == 105){//学院
        [_mBtnCollege setTitle:resultString forState:UIControlStateNormal];

        for (int i = 0; i < _data.count; i++) {
            SchoolInfos *info = _data[i];
            if ([info.name isEqualToString:resultString]) {
                _collegeid = info.key_id;
                return;
            }
            
        }

    }else if(pickView.tag == 103){//班级
        [_mBtnClass setTitle:resultString forState:UIControlStateNormal];

        for (int i = 0; i < _data.count; i++) {
            SchoolInfos *info = _data[i];
            if ([info.name isEqualToString:resultString]) {
                _classid = info.key_id;
                return;
            }
            
        }
        
    }else if(pickView.tag == 100){//年
        _year = resultString;
        [_mBtnYear setTitle:_year forState:UIControlStateNormal];
    }else if(pickView.tag == 101){//月
        _month = resultString;
        [_mBtnMonth setTitle:_month forState:UIControlStateNormal];
    }else if(pickView.tag == 102){//日
        _day = resultString;
        [_mBtnDay setTitle:_day forState:UIControlStateNormal];
    }
}

//选择收货地址
-(IBAction)onChooseAddress:(id)sender{
    AddressListVC *addressVC = (AddressListVC *)[UIViewController viewControllerWithStoryboard:@"Address" identifier:@"AddressListVC"];

    [self.navigationController pushViewController:addressVC animated:YES];
}

- (void)exitEditMode{
    [_mEditName resignFirstResponder];
    [_mEditNumber resignFirstResponder];
    [_mEditMail resignFirstResponder];
    
    if (_mDataPickview) {
        [_mDataPickview remove];
        _mDataPickview = nil;
    }
}

//
-(BOOL)bissextile:(int)year {
    if ((year%4==0 && year %100 !=0) || year%400==0) {
        return YES;
    }else {
        return NO;
    }
    return NO;
}
@end
