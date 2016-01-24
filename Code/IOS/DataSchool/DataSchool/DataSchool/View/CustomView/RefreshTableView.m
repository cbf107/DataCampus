//
//  RefreshTableView.m
//  MarketEleven
//
//  Created by Bergren Lam on 1/8/15.
//  Copyright (c) 2015 Meinekechina. All rights reserved.
//

#import "RefreshTableView.h"


@interface RefreshTableView ()

@property (nonatomic, assign)RefreshTableViewStatus status;

@end

@implementation RefreshTableView

- (void)dealloc {
    [self.request stop];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.dataArray = [[NSMutableArray alloc] init];
    self.needHeader = YES;
    self.needFooter = YES;
}

- (void)addHeader {
    [self addHeaderWithTarget:self action:@selector(headerRereshing)];
}

- (void)headerRereshing {
    self.request.pageStart = 1;
    
    [self.request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
        [self headerEndRefreshing];
    
        [self.dataArray removeAllObjects];
        NSArray *arr = request.responseObject;
        
        if (arr.count > 0) {
            [self.dataArray addObjectsFromArray:arr];
        }
        [self reloadData];
        
        
        //根据需要添加删除header或footer
        if (self.needHeader) {
            [self addHeader];
        }
        if (self.needFooter) {
            //如果数据少于分页数量, 则移除footer， 否则没有footer的话就加上
            if (arr.count < request.pageLength) {
                [self removeFooter];
            }else {
                [self addFooter];
            }
        }
        
        
        if (self.dataArray.count == 0) {
            [self callRefreshStatusBlock:RefreshTableViewStatusNoResult];
        }else {
            [self callRefreshStatusBlock:RefreshTableViewStatusNormal];
        }
        
    } failure:^(NSError *err) {
        [self headerEndRefreshing];
        
        [self.dataArray removeAllObjects];
        [self removeFooter];
        [self reloadData];
        
        //根据需要添加删除header或footer
        if (self.needHeader) {
            [self addHeader];
        }
        
        NSInteger code = err.code;
        if ([err.domain isEqualToString:NSURLErrorDomain] && code == NSURLErrorCannotConnectToHost) {
            [self callRefreshStatusBlock:RefreshTableViewStatusNoNetwork];
        }else{
            [self callRefreshStatusBlock:RefreshTableViewStatusLoadError];
        }
    }];
}

- (void)callRefreshStatusBlock:(RefreshTableViewStatus)status {
    if (self.refreshStatusViewBlock) {
        self.refreshStatusViewBlock(status);
    }
}

- (void)addFooter {
    [self addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (void)footerRereshing {
    self.request.pageStart = self.dataArray.count/self.request.pageLength + 1;
    
    [self.request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
        [self footerEndRefreshing];
        NSArray *arr = request.responseObject;
        if (arr.count > 0) {
            [self.dataArray addObjectsFromArray:arr];
            [self reloadData];
        }
        
        if (arr.count < request.pageLength) {
            [self removeFooter];
        }
    } failure:^(NSError *err) {
        [self footerEndRefreshing];
    }];
}


- (void)begainLoadData{
    self.request.pageStart = 1;
    
    [self.request startWithCompletionBlockWithSuccess:^(BaseRequest *request) {
        
        [self.dataArray removeAllObjects];
        NSArray *arr = request.responseObject;
        
        if (arr.count > 0) {
            [self.dataArray addObjectsFromArray:arr];
        }
        [self reloadData];
        
        if (self.dataArray.count == 0) {
            [self callRefreshStatusBlock:RefreshTableViewStatusNoResult];
        }else {
            [self callRefreshStatusBlock:RefreshTableViewStatusNormal];
        }
        
    } failure:^(NSError *err) {
        [self.dataArray removeAllObjects];
        [self reloadData];
        
        NSInteger code = err.code;
        if ([err.domain isEqualToString:NSURLErrorDomain] && code == NSURLErrorCannotConnectToHost) {
            [self callRefreshStatusBlock:RefreshTableViewStatusNoNetwork];
        }else{
            [self callRefreshStatusBlock:RefreshTableViewStatusLoadError];
        }
    }];
}

- (void)reloadData {
    [super reloadData];
    if (self.dataArray.count == 0) {
        [self callRefreshStatusBlock:RefreshTableViewStatusNoResult];
    }else {
        [self callRefreshStatusBlock:RefreshTableViewStatusNormal];
    }
}
@end



@interface RefreshStatusView ()

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *tipsLabel;

@end

@implementation RefreshStatusView

- (void)commonInit {
    
    self.backgroundColor = [UIColor clearColor];
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.font = [UIFont systemFontOfSize:kAppFontSizeContent];
    self.tipsLabel.textColor = [UIColor colorWithHexString:kAppFontColorLight];
    self.tipsLabel.numberOfLines = 0;
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.imageView];
    [self addSubview:self.tipsLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(self, _imageView, _tipsLabel);
    
    NSArray *c1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-105-[_imageView]-15-[_tipsLabel]" options:0 metrics:nil views:views];
    [self addConstraints:c1];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_tipsLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (RefreshStatusView *)initWithImageName:(NSString *)name text:(NSString *)text {
    if (self = [super init]) {
        [self commonInit];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
        self.imageView.image = [UIImage imageNamed:name];
        self.tipsLabel.text = text;
    }
    return self;
}

+(RefreshStatusView *)statusViewWithStatus:(RefreshTableViewStatus)status {
    switch (status) {
        case RefreshTableViewStatusNormal:
            return nil;
        case RefreshTableViewStatusNoResult: {
            return [[self alloc] initWithImageName:@"tip_data_img" text:@"没有相关数据"];
        }
        case RefreshTableViewStatusNoNetwork: {
            return [[self alloc] initWithImageName:@"tip_nowifi_img" text:@"亲，你的网络不给力哟"];
        }
        case RefreshTableViewStatusLoadError: {
            return [[self alloc] initWithImageName:@"tip_data_img" text:@"数据加载失败"];
        }
        default:
            return nil;
    }
}



@end
