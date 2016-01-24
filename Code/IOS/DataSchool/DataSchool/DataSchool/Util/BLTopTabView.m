//
//  BLTopTabView.m
//  MarketEleven
//
//  Created by Bergren Lam on 12/15/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//
#define IndicatorHeight 2.0

#import "BLTopTabView.h"

@interface BLTopTabView ()
@property (nonatomic, strong)NSMutableArray *buttons;
@property (nonatomic, strong)UIView *indicator;
@property (nonatomic, strong)UIView *lineView;


@end

@implementation BLTopTabView

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
    self.buttons = [[NSMutableArray alloc] init];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:kAppColorGraybkg];
    [self addSubview:_lineView];
    
    self.indicator = [[UIView alloc] init];
    self.indicator.backgroundColor = [UIColor colorWithHexString:kAppFontColorTopTab];
    [self addSubview:self.indicator];
}

- (void)setTitles:(NSArray *)titles {
    if (_titles != titles) {
        _titles = titles;
        
        
        [self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.buttons removeAllObjects];
        
        for (int i = 0; i < _titles.count; i++) {
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            b.tag = i;
            
            [b setTitle:_titles[i] forState:UIControlStateNormal];
            [b setTitleColor:[UIColor colorWithHexString:kAppFontColorNormal] forState:UIControlStateNormal];
            [b setTitleColor:[UIColor colorWithHexString:kAppFontColorTopTab] forState:UIControlStateSelected];
            [b setTitleColor:[UIColor colorWithHexString:kAppFontColorTopTab] forState:UIControlStateHighlighted];
            b.backgroundColor = [UIColor whiteColor];
            
            b.titleLabel.font = [UIFont systemFontOfSize:17];
            
            
            [b addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:b];
            [self.buttons addObject:b];
            
            
            
        }
        
        
        [self bringSubviewToFront:self.indicator];
        
        
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews {
    float width = self.frame.size.width / self.buttons.count;
    float height = self.frame.size.height;
    
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *b = self.buttons[i];
        b.frame = CGRectMake(i * width, 0, width, height-2);
    }
    
    self.lineView.frame = CGRectMake(0, height-2, self.frame.size.width, 2);
}



-(void)onButton:(UIButton *)button {
    if (button.selected) {
        return;
    }
    [self selectIndex:button.tag];
}


-(void)selectIndex:(NSInteger)index {
    
    for (UIButton *button in self.buttons) {
        if (button.tag == index) {
            button.selected = YES;
        }else {
            button.selected = NO;
        }
    }
    
    float width = self.frame.size.width / self.buttons.count;
    float height = self.frame.size.height;
    
    [UIView animateWithDuration:0.15 animations:^{
        self.indicator.frame = CGRectMake(index * width, height - IndicatorHeight, width, IndicatorHeight);
    }];
    
    if (self.changedBlock) {
        self.changedBlock(index);
    }
}

@end
