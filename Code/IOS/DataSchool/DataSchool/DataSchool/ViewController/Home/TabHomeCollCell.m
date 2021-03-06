//
//  TabHomeCollCell.m
//  WanDaCloud
//
//  Created by mac on 15/8/28.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "TabHomeCollCell.h"
#import "SysRequest.h"
#import "UIImageView+WebCache.h"
#import "UniversalVC.h"

@interface TabHomeImgScrollCell()
@property (nonatomic, weak) IBOutlet InfiniteScrollContainer *mImgContainer;
@property (nonatomic, weak) IBOutlet UILabel *mTitle;

@property (nonatomic, retain) NSMutableArray *mActivityInfoArr;
@end

@implementation TabHomeImgScrollCell
- (void)awakeFromNib {
    //_mActivityInfoArr = [[NSMutableArray alloc]initWithObjects:@"banner1", @"banner2", @"banner3", nil ];
    _mActivityInfoArr = [[NSMutableArray alloc]init];
    _mImgContainer.delegateSC = self;
    [_mImgContainer reloadData];
}

-(void)setInfo:(NSArray*) activeInfoArr {
    if (activeInfoArr.count > 0) {
        [_mActivityInfoArr removeAllObjects];
        [_mActivityInfoArr addObjectsFromArray:activeInfoArr];
        [_mImgContainer reloadData];
        
        UIImageView *bkg = (UIImageView *)[self viewWithTag:100];
        if (bkg != nil) {
            [bkg removeFromSuperview];
        }
    }else{
        CGRect frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
        UIImageView *bkg = [[UIImageView alloc] initWithFrame:frame];
        bkg = [[UIImageView alloc] initWithFrame:frame];
        bkg.contentMode = UIViewContentModeScaleAspectFill;
        [bkg sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"bannerImage"]];

        bkg.tag = 100;
        [self addSubview:bkg];
    }
}

#pragma mark - image scroll view data source and delegate
- (UIView *)infiniteScrollContainer:(InfiniteScrollContainer *)scrollContainer forIndex:(NSInteger)itemIndex{
    
    UIImageView *view = [self.mImgContainer dequeueReusableItem];
    
    CGRect frame = CGRectMake(0.0, 0.0, CGRectGetWidth(scrollContainer.frame), CGRectGetHeight(scrollContainer.frame));
    
    if (!view) {
        view = [[UIImageView alloc] initWithFrame:frame];
        view.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleToFill;
    }
    view.frame = frame;

    if (_mActivityInfoArr.count > 0) {
        ActiveInfo *info = ((ActiveInfo*)_mActivityInfoArr[itemIndex]);
        NSString *coverURL = [NSString stringWithFormat:@"%@%@", kServerAddressTest, info.Cover];
        [view sd_setImageWithURL:[NSURL URLWithString:coverURL] placeholderImage:[UIImage imageNamed:@"bannerImage"]];

        _mTitle.text = info.Title;
        //[view setImage:[UIImage imageNamed:@"bannerImage"]];
    }
    
    return view;
}

- (NSUInteger)numberOfItemsInInfiniteScrollContainer:(InfiniteScrollContainer *)scrollContainer{
    return _mActivityInfoArr?[_mActivityInfoArr count]:0;
}

- (CGFloat)infiniteScrollContainer:(InfiniteScrollContainer *)scrollContainer widthForIndex:(NSInteger)itemIndex {
    
    return CGRectGetWidth(scrollContainer.frame);
}

- (void)infiniteScrollContainer:(InfiniteScrollContainer *)scrollContainer didSelectItem:(UIView *)item atIndex:(NSInteger)itemIndex{
    if (_mActivityInfoArr.count > 0) {
        UniversalVC *universal = (UniversalVC *)[UIViewController viewControllerWithStoryboard:@"Universal" identifier:@"UniversalVC"];
        
        School_News *news = _mActivityInfoArr[itemIndex];
        universal.mURL = news.Url;
        universal.title = news.Title;
        
        if (news) {
            UIViewController *currentVC = nil;
            for (UIView* next = [self superview]; next; next = next.superview) {
                UIResponder *nextResponder = [next nextResponder];
                if ([nextResponder isKindOfClass:[UIViewController class]]) {
                    currentVC = (UIViewController *)nextResponder;
                    break;
                }
            }
            
            if (currentVC) {
                [currentVC.navigationController pushViewController:universal animated:YES];;
            }
        }
    }
}

@end

@interface TabHomeActiveCell()
@property (nonatomic, weak) IBOutlet UILabel *mTitle;
@property (nonatomic, weak) IBOutlet UILabel *mContent;
@property (nonatomic, weak) IBOutlet UILabel *mTime;
@property (nonatomic, weak) IBOutlet UIImageView *mImage;

@end
@implementation TabHomeActiveCell
/*-(void)setInfo:(ActiveInfo*) activeInfo {
    [_mImg sd_setImageWithURL:[NSURL URLWithString:activeInfo.sImgPath]];
}*/

/*-(void)setInfo:(NSArray*) activeInfo{
    [_mImg setImage:[UIImage imageNamed:@"active_bar"]];
}*/
-(void)setInfo:(School_News*) activeInfo{
    [_mTitle setText:activeInfo.Title];
    [_mContent setText:activeInfo.Content];
    [_mTime setText:activeInfo.PublicTime];
    
    NSString *coverURL = [NSString stringWithFormat:@"%@%@", kServerAddressTest, activeInfo.Cover];
    NSLog(@"coverURL = %@", coverURL);
    [_mImage sd_setImageWithURL:[NSURL URLWithString:coverURL] placeholderImage:[UIImage imageNamed:@"schoolIcon"]];
}

@end