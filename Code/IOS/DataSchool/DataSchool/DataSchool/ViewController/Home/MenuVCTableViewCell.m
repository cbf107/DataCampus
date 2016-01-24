//
//  MenuVCTableViewCell.m
//  ZhiKu
//
//  Created by coreyfu on 15/5/28.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "MenuVCTableViewCell.h"

@implementation MenuVCTableViewCell
- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setInfo:(Menu *)menuItem {
    [_mMenuName setText:menuItem.MenuName];
}

@end
