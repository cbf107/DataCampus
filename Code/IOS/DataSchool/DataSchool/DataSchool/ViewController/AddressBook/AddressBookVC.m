//
//  Register2VC.m
//  ZhiKu
//
//  Created by mac on 15/5/22.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "AddressBookVC.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ChineseString.h"
#import "AddressBookCell.h"
#import "TKAddressBook.h"

@implementation AddressBookVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionIndexColor=[UIColor colorWithHexString:@"168afc"];
     _addressBookTemp = [NSMutableArray array];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];

    [self getAddressBook];

    NSArray<TKAddressBook> *contactToSort = [_addressBookTemp copy];
    
    [self getAddressBookStatus:contactToSort];
    //self.indexArray = [ChineseString IndexArray:contactToSort];
    //self.LetterResultArr = [ChineseString LetterSortArray:contactToSort];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
}

#pragma mark -Section的Header的值
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [_indexArray objectAtIndex:section];
    return key;
}

#pragma mark - Section header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    lab.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    lab.text = [_indexArray objectAtIndex:section];
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
    return 44.0f;
}

#pragma mark -
#pragma mark Table View Data Source Methods
#pragma mark -设置右方表格的索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexArray;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

#pragma mark -允许数据源告知必须加载到Table View中的表的Section数。
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_indexArray count];
}
#pragma mark -设置表格的行数为数组的元素个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.LetterResultArr objectAtIndex:section] count];
}
#pragma mark -每一行的内容为数组相应索引的值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableCellIdentifier = @"AddressBookCell";
    
    AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 TableCellIdentifier];
    if (cell != nil) {
        TKAddressBook *contact = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        
        [cell setInfo:contact];
        
        cell.mIndexPath = indexPath;
    }
    
    return cell;
}


-(void)getAddressBook{
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        
    //获取通讯录权限
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        TKAddressBook *addressBook = [[TKAddressBook alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);
        addressBook.status = @"0";
        addressBook.mUserIds = @"0";
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.tel = [(__bridge NSString*)value stringByReplacingOccurrencesOfString:@"-" withString:@""];
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [_addressBookTemp addObject:addressBook];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
}

-(void)getAddressBookStatus:(NSArray<TKAddressBook> *)contactToSort {
    GetMobileStatusRequest *request = [[GetMobileStatusRequest alloc] init];
    request.mContacts = contactToSort;
    
    [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
        [SVProgressHUD dismiss];

        self.indexArray = [ChineseString IndexArray:[request parseResult]];
        self.LetterResultArr = [ChineseString LetterSortArray:[request parseResult]];
        [self.tableView reloadData];
    } failure:^(NSError *err) {
        [SVProgressHUD dismiss];
        
        [[[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];

}
@end
