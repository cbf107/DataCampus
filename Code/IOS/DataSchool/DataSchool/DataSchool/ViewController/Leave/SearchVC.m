//
//  ConfirmOrderBookCell.m
//
//  Created by coreyfu on 14-9-15.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//

#import "SearchVC.h"
#import "LeaveRequest.h"
#import "LeaveInfo.h"
#import "MMCell2.h"
#import "ChineseString.h"

@interface SearchVC()< UITableViewDataSource , UITableViewDelegate , UISearchDisplayDelegate , UISearchBarDelegate >

@property ( nonatomic , strong ) NSMutableArray *dataArr; // 数据源
@property ( nonatomic , strong ) NSArray *resultsArr; // 搜索结果
@property ( nonatomic , strong ) UISearchBar *search;
@property ( nonatomic , strong ) UISearchDisplayController * searchPlay;
@property ( nonatomic , strong ) UITableView *aTableView;

@end

@implementation SearchVC

- (id)initWithNibName:( NSString *)nibNameOrNil bundle:( NSBundle *)nibBundleOrNil
{
    self = [ super initWithNibName :nibNameOrNil bundle :nibBundleOrNil];
    if ( self ) {
        // Custom initialization
    }
    
    return self ;
}

- (void)viewDidLoad
{
    
    [ super viewDidLoad ];
    
    self.title = _mTitle;
    [self initData];
    [self createView];
    // Do any additional setup after loading the view.
}

-(void)initData{
    LeaveTeacherRequest *request = [[LeaveTeacherRequest alloc]init];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
        [SVProgressHUD dismiss];
        
        _dataArr = [[NSMutableArray alloc] init];
        
        NSArray *leaveArray = request.parseResult;
        for (int i = 0; i < leaveArray.count; i++) {
            [_dataArr addObject:leaveArray[i]];
        }
        
        self.indexArray = [ChineseString IndexArray:_dataArr];
        self.LetterResultArr = [ChineseString LetterSortArray:[request parseResult]];

        [self.aTableView reloadData];
        
    }failure:^(NSError *err) {
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];

}


-(void)createView
{
    _aTableView = [[ UITableView alloc ] initWithFrame:CGRectMake (0, 0, self.view.frame.size.width , self.view.frame.size.height )];
    _aTableView.delegate = self;
    _aTableView.dataSource = self;
    [self.view addSubview:_aTableView ];
    
    _search = [[ UISearchBar alloc ] initWithFrame:CGRectMake (0, 0, _aTableView.bounds.size.width, 40 )];//self.view.frame.size.width
    _search.backgroundColor = [UIColor clearColor];
    _search.delegate = self ;
    //_search.showsCancelButton = YES ;
    _search.keyboardType = UIKeyboardTypeDefault ;
    [_search setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_search sizeToFit];
    _aTableView.tableHeaderView = _search;

    _searchPlay = [[ UISearchDisplayController alloc ] initWithSearchBar:self.search contentsController:self];
    _searchPlay.delegate = self;
    _searchPlay.searchResultsDataSource = self;
    _searchPlay.searchResultsDelegate = self;
}

#pragma mark -
#pragma mark Table View Data Source Methods
#pragma mark -设置右方表格的索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([tableView isEqual : self.searchPlay.searchResultsTableView ]) {
        return nil;
    }
    
    return _indexArray;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([tableView isEqual : self.searchPlay.searchResultsTableView ]) {
        return 0;
    }

    return index;
}

#pragma mark -允许数据源告知必须加载到Table View中的表的Section数。
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual : self.searchPlay.searchResultsTableView ]) {
        return 1;
    }

    return [_indexArray count];
}
#pragma mark -设置表格的行数为数组的元素个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0 ;
    
    if ([tableView isEqual : self.searchPlay.searchResultsTableView ]) {
        row = [self.resultsArr count];
    } else {
        //row = [self.dataArr count];
        row = [[self.LetterResultArr objectAtIndex:section] count];
    }
    
    return row;

}

#pragma mark -Section的Header的值
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual : self.searchPlay.searchResultsTableView ]) {
        return @"";
    }

    NSString *key = [_indexArray objectAtIndex:section];
    return key;
}

#pragma mark - Section header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual : self.searchPlay.searchResultsTableView ]) {
        return nil;
    }

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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


#pragma mark UITableViewDelegate
- (BOOL)searchBarShouldEndEditing:( UISearchBar *)searchBar
{
    return YES;
}

- ( UITableViewCell *)tableView:( UITableView *)tableView cellForRowAtIndexPath:( NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MMCell2" ;
    MMCell2 *cell = [tableView dequeueReusableCellWithIdentifier :CellIdentifier];
    
    if (!cell) {
        cell = [[MMCell2 alloc] initWithStyle : UITableViewCellStyleDefault reuseIdentifier :CellIdentifier];
    }
    
    if ([tableView isEqual:self.searchPlay.searchResultsTableView ]) {
        LeaveTeacher *type = [_resultsArr objectAtIndex:indexPath.row];
        cell.textLabel.text = type.TeacherName;
        
        NSString *coverURL = [NSString stringWithFormat:@"%@%@", kServerAddressTest, type.TeacherPic];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:coverURL] placeholderImage:[UIImage imageNamed:@"schoolIcon"]];

    } else {
        //LeaveTeacher *type = [_dataArr objectAtIndex:indexPath.row];
        LeaveTeacher *type = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        cell.textLabel.text = type.TeacherName;
        
        NSString *coverURL = [NSString stringWithFormat:@"%@%@", kServerAddressTest, type.TeacherPic];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:coverURL] placeholderImage:[UIImage imageNamed:@"schoolIcon"]];
    }
    
    return cell;
}

#pragma mark -

#pragma mark UISearchDisplayControllerDelegate

//text 是输入的文本 ,scope 是搜索范围

- (void)searchText:(NSString *)text andWithScope:(NSString *)scope
{
    //CONTAINS 是字符串比较操作符，
    //NSPredicate *result = [ NSPredicate predicateWithFormat:@"SELF contains[cd] %@" ,text];
    //self.resultsArr = [ self.dataArr filteredArrayUsingPredicate:result];

    NSPredicate *pre = [NSPredicate predicateWithFormat:@"TeacherName contains[cd] %@" ,text];
    self.resultsArr=[self.dataArr filteredArrayUsingPredicate:pre];

}

- (BOOL) searchDisplayController:( UISearchDisplayController *)controller shouldReloadTableForSearchString:( NSString *)searchString
{
    // searchString 是输入的文本
    
    // 返回结果数据 读取搜索范围 在选择范围
    NSArray *searScope = [ self.searchPlay.searchBar scopeButtonTitles]; // 数组范围
    
    [ self searchText:searchString andWithScope:[searScope objectAtIndex:[self.searchPlay. searchBar selectedScopeButtonIndex ]]];
    
    return YES ;
}

- (BOOL) searchDisplayController:( UISearchDisplayController *)controller shouldReloadTableForSearchScope:( NSInteger )searchOption
{
    NSString *inputText = self.searchPlay.searchBar.text ; // 搜索输入的文本
    NSArray *searScope = [ self.searchPlay.searchBar scopeButtonTitles ]; // 索索范围
    
    [self searchText:inputText andWithScope:[searScope objectAtIndex:searchOption]];
    
    return YES ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *name;
    
    if ([tableView isEqual:self.searchPlay.searchResultsTableView ]) {
        LeaveTeacher *type = [_resultsArr objectAtIndex:indexPath.row];
        name = type.TeacherName;
    } else {
        LeaveTeacher *type = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]
;
        name = type.TeacherName;
    }
    
    if (self.delegate) {
        [self.delegate selectData:name];
    }

    [self.navigationController popViewControllerAnimated:YES];
}


@end

