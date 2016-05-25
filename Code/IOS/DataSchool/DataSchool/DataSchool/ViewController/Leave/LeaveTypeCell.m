//
//  ConfirmOrderBookCell.m
//
//  Created by coreyfu on 14-9-15.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//
#import "LeaveTypeCell.h"

@implementation LeaveTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];

    [self initImgBtn:_mBtnType];
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
